const { OrderItem } = require('../models');

const normalizeOrderItemPayload = (body) => ({
  orderId: body.orderId ?? body.order_id,
  productId: body.productId ?? body.product_id,
  quantity: body.quantity,
  subtotal: body.subtotal
});

const createOrderItem = async (req, res, next) => {
  try {
    const payload = normalizeOrderItemPayload(req.body);
    const orderItem = await OrderItem.create(payload);

    return res.status(201).json({
      message: 'Order item creado correctamente',
      data: orderItem
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  createOrderItem
};