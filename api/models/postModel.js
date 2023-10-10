import mongoose from "mongoose";

const postSchema = new mongoose.Schema({
  uid: { type: mongoose.Types.ObjectId, required: true, ref: 'users'},
  imageUrl: { type: String, required: true },
  caption: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  expireAt: { type: Date, index: { expires: '10m' } }, // Add index to automatically delete expired documents
  recipients: [{ type: mongoose.Types.ObjectId, required: true, ref: 'users'}]
});

export default mongoose.model('post', postSchema);