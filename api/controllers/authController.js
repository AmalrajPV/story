import userModel from "../models/userModel.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

export const login = (data) => {
  return new Promise(async (resolve, reject) => {
    let User = await userModel.findOne({ email: data.email });
    if (!User) {
      return reject({ message: "user not found" });
    }
    bcrypt
      .compare(data.password, User.password)
      .then(() => {
        const access_token = jwt.sign(
          { id: User._id, email: User.email },
          process.env.SECRET
        );
        return resolve({ access_token });
      })
      .catch((e) => {
        console.log(e);
        return reject({ message: "Invalid credentials" });
      });
  });
};

export const register = (data) => {
  return new Promise((resolve, reject) => {
    try {
      const salt = bcrypt.genSaltSync(10);
      const hash = bcrypt.hashSync(data.password, salt);
      data.password = hash;
      userModel
        .create(data)
        .then((res) => resolve(res))
        .catch((err) => reject(err));
    } catch (error) {
      return reject(error);
    }
  });
};
