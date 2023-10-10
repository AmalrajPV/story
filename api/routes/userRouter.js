import express from "express";
import { editUser, userDetails, userList } from "../controllers/userController.js";
import { verifyToken } from "../middewares/authMiddlewares.js";

const router = express.Router();

router.get('/hello', (req, res)=>{
    res.send("hello world");
})

// Get list of users
router.get('/', verifyToken, (req, res, next)=>{
    userList(req.user.id).then(r=>res.status(200).json(r)).catch(e=>res.sendStatus(400));
});

// Get user by id
router.get('/profile/:id', verifyToken, (req, res, next)=>{
    userDetails(req.params.id).then(r=>res.status(200).json(r)).catch(e=>res.status(400).json({msg:"err"}));
});

router.get('/profile', verifyToken, (req, res)=>{
    userDetails(req.user.id).then(r=>res.status(200).json(r)).catch(e=>res.status(400).json({msg:e}));
})

// Edit user details
router.put('/:id', verifyToken, (req, res, next)=>{
    if (req.user.id == req.params.id) {
        editUser(req.params.id, req.body).then(r=>res.status(200).json(r)).catch(e=>res.sendStatus(400));
    }
    res.status(403).json({message:"no permission"});
});

export default router;
