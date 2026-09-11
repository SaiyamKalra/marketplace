import { Request, Response } from "express";
import { loginWithFirebase } from "../modules/auth/auth.service";

export async function firebaseLogin(
    req: Request,
    res: Response
) {
    try {

        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({
                message: "Firebase ID token is required",
            });
        }

        const idToken = authHeader.split(" ")[1];

        const result = await loginWithFirebase(idToken);

        return res.status(200).json({
            message: "Login successful",
            ...result,
        });

    } catch (error) {

        console.error(error);

        return res.status(401).json({
            message: "Authentication failed",
        });
    }
}