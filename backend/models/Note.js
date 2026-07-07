const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'User',
    },
    title: {
      type: String,
      required: true,
    },
    content: {
      type: String,
      required: true,
    },
    tags: [
      {
    type: String,
    trim: true,
    lowercase: true,
    maxlength: 10
  }
    ],

    isPinned: {
      type: Boolean,
      default: false
    },

    isArchived: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true,
  }
);

// noteSchema.index({ user: 1, createdAt: -1 }, { background: true });

noteSchema.index({
  title: "text",
  content: "text",
  tags: "text"
},{
  weights: {
    title: 5,
    tags: 3,
    content: 2
  }
});
const Note = mongoose.model('Note', noteSchema);
module.exports = Note;
