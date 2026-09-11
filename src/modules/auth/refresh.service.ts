import crypto from "crypto";
import { prisma } from "../../lib/prisma";
import { generateRefreshToken } from "./jwt.service";

function hashRefreshToken(token: string) {
    return crypto
        .createHash("sha256")
        .update(token)
        .digest("hex");
}

export async function createRefreshToken(userId: string) {
    const refreshToken = generateRefreshToken();

    const tokenHash = hashRefreshToken(refreshToken);

    const expiresAt = new Date();

    expiresAt.setDate(expiresAt.getDate() + 30);

    await prisma.refreshToken.create({
        data: {
            userId,
            tokenHash,
            expiresAt,
        },
    });

    return refreshToken;
}