const sequelize = require('../config/database');

const Category = require('./category')(sequelize);
const Product = require('./product')(sequelize);
const User = require('./user')(sequelize);
const Order = require('./order')(sequelize);
const OrderItem = require('./orderItem')(sequelize);

Category.hasMany(Product, { foreignKey: 'categoryId', as: 'products' });
Product.belongsTo(Category, { foreignKey: 'categoryId', as: 'category' });

User.hasMany(Order, { foreignKey: 'userId', as: 'orders' });
Order.belongsTo(User, { foreignKey: 'userId', as: 'user' });

Order.hasMany(OrderItem, { foreignKey: 'orderId', as: 'items' });
Product.hasMany(OrderItem, { foreignKey: 'productId', as: 'orderItems' });
OrderItem.belongsTo(Order, { foreignKey: 'orderId', as: 'order' });
OrderItem.belongsTo(Product, { foreignKey: 'productId', as: 'product' });

module.exports = {
  sequelize,
  Category,
  Product,
  User,
  Order,
  OrderItem
};