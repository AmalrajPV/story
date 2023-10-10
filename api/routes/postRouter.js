import express from "express";
import { verifyToken } from "../middewares/authMiddlewares.js";
import postModel from "../models/postModel.js";
import { upload } from "../middewares/imageMiddleware.js";

const router = express.Router();

// Create post
router.post('/', verifyToken, upload.single('image'), async(req, res, next)=>{
    try {
        const { recipients, caption } = req.body;
        const post = await postModel.create({
          uid: req.user.id,
          imageUrl: '/uploads/' + req.file.filename,
          recipients,
          caption,
          expireAt: new Date(Date.now() + 10 * 60 * 1000),
        });
        res.status(200).json(post);
      } catch (err) {
        res.status(400).json({message:err.message});
      }
});

// Show post user recived
router.get('/', verifyToken, async (req, res) => {
    try {
      const posts = await postModel.find({
        recipients: req.user.id,
        expireAt: { $gte: new Date() },
      },{recipients: 0})
        .populate('uid', 'username email image');
      res.status(200).json(posts);
    } catch (err) {
      res.status(400).json({message:err.message});
    }  
});

// Show post i made
router.get('/mypost', verifyToken, async (req, res) => {
    try {
      const posts = await postModel.find({
        uid: req.user.id,
        expireAt: { $gte: new Date() },
      },)
        .populate('uid', 'username email image');
      res.status(200).json(posts);
    } catch (err) {
      res.status(400).json({message:err.message});
    }  
});

// // Show post in detail
// router.get('/:id', verifyToken, (req, res, next)=>{

// });

export default router;
