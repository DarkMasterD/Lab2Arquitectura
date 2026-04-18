const express = require('express');
const { createOrderItem } = require('../controllers/orderItemController');

const router = express.Router();

router.post('/', createOrderItem);

module.exports = router;