const express = require('express');
const router = express.Router();
const {
  registerUser,
  authUser,
  getUser,
  updateUserProfile
} = require('../controllers/authController');
const protect = require('../middleware/authMiddleware');

router.post('/register', registerUser);
router.post('/login', authUser);
router.get('/profile', protect, getUser);
router.put('/profile', protect, updateUserProfile);

module.exports = router;
