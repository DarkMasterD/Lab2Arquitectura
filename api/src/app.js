const express = require('express');
const orderItemRoutes = require('./routes/orderItemRoutes');
const reportRoutes = require('./routes/reportRoutes');

const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/order-items', orderItemRoutes);
app.use('/reports', reportRoutes);

app.use((error, req, res, next) => {
  const statusCode = error.message.includes('no coincide') || error.message.includes('no encontrado') ? 400 : 500;

  return res.status(statusCode).json({
    message: error.message || 'Internal server error'
  });
});

module.exports = app;