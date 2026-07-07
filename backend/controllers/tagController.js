const asyncHandler = require('express-async-handler');
const Note = require('../models/Note');
const suggestedTags = require('../constants/suggestedTags');

const getSuggestedTags = asyncHandler(async (req, res) => {
  res.json(suggestedTags);
});

const getAllTags = asyncHandler(async (req, res) => {
  const notes = await Note.find({ user: req.user._id }).select('tags');
  const tagSet = new Set();
  notes.forEach(note => {
    if (note.tags && Array.isArray(note.tags)) {
      note.tags.forEach(tag => {
        const cleanTag = tag.trim().toLowerCase();
        if (cleanTag) {
          tagSet.add(cleanTag);
        }
      });
    }
  });

  // 2. ✅ Loops ke BAHAR sirf EK BAAR response bhejo
  res.json(Array.from(tagSet));
});


module.exports = {
  getSuggestedTags,
  getAllTags
};