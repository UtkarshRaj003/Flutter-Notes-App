const asyncHandler = require('express-async-handler');
const Note = require('../models/Note');
const sanitizeTags = require('../utils/tagUtils');


const getNotes = asyncHandler(async (req, res) => {
  const { search, tag, isPinned, isArchived, page = 1, limit = 10 } = req.query;



  //  Base query: Always restrict to the logged-in user
  let query = { user: req.user._id };

  // Text Search Integration
  if (search) {
    query.$text = { $search: search };
  }

  //  Filter by specific Tag
  if (tag) {
    query.tags = tag; // MongoDB automatically searches inside arrays
  }

  //  Filter by Pinned status
  if (isPinned === 'true') {
    query.isPinned = true;
  }


  //  Filter by Archived status
  if (isArchived === 'true') {
    query.isArchived = true;
  } else {
    query.isArchived = false; // Home page par archived notes hamesha hidden rahenge
  }

  const pageNumber = Number(page);
  const limitNumber = Number(limit);

  const skip = (pageNumber - 1) * limitNumber;

  let dbQuery = Note.find(query);


  if (search) {
    dbQuery = dbQuery
      .select({ score: { $meta: 'textScore' } })
      .sort({ score: { $meta: 'textScore' } });
  } else {
    dbQuery = dbQuery.sort({ isPinned: -1, createdAt: -1 });
  }

  const notes = await dbQuery.skip(skip)
    .limit(limitNumber);
  const total = await Note.countDocuments(query);
  res.json({
    notes,
    currentPage: pageNumber,
    totalPages: Math.ceil(total / limitNumber),
    totalNotes: total
  });
});


const getNoteById = asyncHandler(async (req, res) => {
  const note = await Note.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error('Note not found');
  }

  // Check authorization
  if (note.user.toString() !== req.user._id.toString()) {
    res.status(401);
    throw new Error('Not authorized to view this note');
  }

  res.json(note);
});


const createNote = asyncHandler(async (req, res) => {
  const { title, content, tags, isPinned, isArchived } = req.body;

  if (!title || !content) {
    res.status(400);
    throw new Error('Title and content are required fields');
  }

  const note = await Note.create({
    user: req.user._id,
    title,
    content,
    tags: sanitizeTags(tags),
    isPinned: isPinned || false,
    isArchived: isArchived || false
  });

  res.status(201).json(note);
});


const updateNote = asyncHandler(async (req, res) => {
  const note = await Note.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error('Note not found');
  }

  // Check authorization
  if (note.user.toString() !== req.user._id.toString()) {
    res.status(401);
    throw new Error('Not authorized to update this note');
  }


  note.title = req.body.title !== undefined ? req.body.title : note.title;
  note.content = req.body.content !== undefined ? req.body.content : note.content;
  note.tags = req.body.tags !== undefined ? sanitizeTags(req.body.tags) : note.tags;
  note.isPinned = req.body.isPinned !== undefined ? req.body.isPinned : note.isPinned;
  note.isArchived = req.body.isArchived !== undefined ? req.body.isArchived : note.isArchived;

  const updatedNote = await note.save();
  res.json(updatedNote);
});


const deleteNote = asyncHandler(async (req, res) => {
  const note = await Note.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error('Note not found');
  }

  // Check authorization
  if (note.user.toString() !== req.user._id.toString()) {
    res.status(401);
    throw new Error('Not authorized to delete this note');
  }


  await Note.deleteOne({ _id: req.params.id });

  res.json({ message: 'Note removed successfully' });
});

module.exports = {
  getNotes,
  getNoteById,
  createNote,
  updateNote,
  deleteNote,
};