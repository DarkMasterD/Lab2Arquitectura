const { DataTypes } = require('sequelize');

const validateSubtotal = async (orderItem, options) => {
  const sequelize = orderItem.sequelize;
  const Product = sequelize.models.Product;

  const product = await Product.findByPk(orderItem.productId || orderItem.get('product_id'), {
    transaction: options.transaction
  });

  if (!product) {
    throw new Error('Error: Producto no encontrado');
  }

  const quantity = Number(orderItem.quantity);
  const expectedSubtotal = Number(product.price) * quantity;
  const providedSubtotal = Number(orderItem.subtotal);

  if (expectedSubtotal.toFixed(2) !== providedSubtotal.toFixed(2)) {
    throw new Error('Error: El subtotal no coincide con Precio * Cantidad');
  }
};

module.exports = (sequelize) => {
  const OrderItem = sequelize.define('OrderItem', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    orderId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'order_id'
    },
    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'product_id'
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1
      }
    },
    subtotal: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    }
  }, {
    tableName: 'order_items',
    hooks: {
      beforeCreate: validateSubtotal,
      beforeUpdate: validateSubtotal
    }
  });

  return OrderItem;
};