const express = require('express');
const { getTotalSoldByCategory } = require('../controllers/reportController');

const router = express.Router();

router.get('/total-sold-by-category', getTotalSoldByCategory);

module.exports = router;