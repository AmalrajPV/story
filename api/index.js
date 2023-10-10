import express from "express";
import userRouter from "./routes/userRouter.js";
import postRouter from "./routes/postRouter.js";
import authRouter from "./routes/authRouter.js";
import mongoose from "mongoose";
import dotenv from "dotenv";
import bodyParser from "body-parser";

const app = express();
dotenv.config();

const connect = () => {
  try {
    mongoose.connect(process.env.DB);
    console.log("connected to database...");
  } catch (error) {
    throw error;
  }
};

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));
app.use('/uploads', express.static('uploads'));
app.use("/users", userRouter);
app.use("/posts", postRouter);
app.use("/auth", authRouter);

app.listen(8000, ()=>{
    connect();
});