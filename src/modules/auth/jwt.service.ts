import jwt from "jsonwebtoken";
import fs from "fs";
import path from "path";
import crypto from "crypto";

const privateKey=fs.readFileSync(
    path.join(process.cwd(), "jwt-private.pem"),
    "utf8"
)

const publicKey=fs.readFileSync(
    path.join(process.cwd(), "jwt-public.pem"),
    "utf8"
)

export function generateAccessToken(userId:string){
    return jwt.sign(
        {
            sub:userId,
        },
        privateKey,
        {
            algorithm: "RS256",
            expiresIn: "15m",
        }
    )
}

export function verifyAccessToken(token: string) {
    return jwt.verify(token, publicKey, {
        algorithms: ["RS256"],
    });
}

export function generateRefreshToken() {
    return crypto.randomBytes(64).toString("hex");
}