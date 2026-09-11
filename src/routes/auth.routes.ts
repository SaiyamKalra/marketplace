import { Router } from "express";
import { firebaseLogin } from "../controllers/auth.controller";

const router = Router();

router.post("/firebase", firebaseLogin);

export default router;