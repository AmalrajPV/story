import userModel from "../models/userModel.js";

export const userList=(id)=>{
    return new Promise((resolve, reject) => {
        userModel.find({'_id': {$ne: id}}).then(res=>resolve(res)).catch(err=>reject(err));
    });
}

export const userDetails=(id)=>{
    return new Promise((resolve, reject) => {
        userModel.findById(id).then(res=>resolve(res)).catch(err=>reject(err));
    });
}

export const editUser=(id, data)=>{
    return new Promise((resolve, reject) => {
        const {username, image} = data
        const updatedUser = {};
        if (username) {
            updatedUser.username = username;
        }
        if (image) {
            updatedUser.image = image;
        }
        userModel.findByIdAndUpdate(id, updatedUser, {new:true}).then(r=>resolve(r)).catch(e=>reject(e));
    })
}