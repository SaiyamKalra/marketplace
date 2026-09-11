import { firebaseAuth } from "../../config/firebase";

export async function verifyFirebaseToken(idToken: string) {
    try {
        const decodedToken = await firebaseAuth.verifyIdToken(idToken);

        return decodedToken;
    } catch (error) {
        console.error("Firebase token verification failed:", error);
        throw new Error("Invalid Firebase ID token");
    }
}