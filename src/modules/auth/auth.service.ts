import { AuthProvider } from "../../generated/prisma/client";
import { prisma } from "../../lib/prisma";
import { verifyFirebaseToken } from "./firebase.service";
import { generateAccessToken } from "./jwt.service";
import { createRefreshToken } from "./refresh.service";

export async function loginWithFirebase(idToken: string) {

    const firebaseUser = await verifyFirebaseToken(idToken);

    if (!firebaseUser.uid) {
        throw new Error("Firebase user has no UID");
    }

    if (!firebaseUser.email) {
        throw new Error("Firebase user has no email");
    }

    const authAccount = await prisma.authAccount.findUnique({
        where: {
            provider_providerUserId: {
                provider: AuthProvider.GOOGLE,
                providerUserId: firebaseUser.uid,
            },
        },
        include: {
            user: true,
        },
    });

    let user;

    if (authAccount) {

        user = authAccount.user;

    } else {

        const existingUser = await prisma.user.findUnique({
            where: {
                email: firebaseUser.email,
            },
        });

        if (existingUser) {
            throw new Error(
                "A user with this email already exists"
            );
        }

        user = await prisma.$transaction(async (tx) => {

            const newUser = await tx.user.create({
                data: {
                    firstName:
                        firebaseUser.name?.split(" ")[0] ?? "",

                    lastName:
                        firebaseUser.name
                            ?.split(" ")
                            .slice(1)
                            .join(" ") ?? "",

                    email: firebaseUser.email!,
                    password: null,
                    status: "ACTIVE",
                },
            });

            await tx.authAccount.create({
                data: {
                    userId: newUser.userId,
                    provider: AuthProvider.GOOGLE,
                    providerUserId: firebaseUser.uid,
                },
            });

            return newUser;
        });
    }

    const accessToken = generateAccessToken(user.userId);

    const refreshToken = await createRefreshToken(user.userId);

    return {
        user,
        accessToken,
        refreshToken,
    };
}