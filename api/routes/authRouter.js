import express from "express";
import { login, register } from "../controllers/authController.js";
import { upload } from "../middewares/imageMiddleware.js";

const router = express.Router();

router.post("/login", (req, res, next) => {
    login(req.body)
        .then((r) => res.status(200).json(r))
        .catch((err) => res.status(400).json(err));
});
router.post("/register", upload.single('image'), (req, res, next) => {
    if (req.file) {
        req.body.image = '/uploads/' + req.file.filename;
    }
    register(req.body)
        .then((r) => res.status(200).json(r))
        .catch((err) => res.status(400).json(err));
});


export default router;
