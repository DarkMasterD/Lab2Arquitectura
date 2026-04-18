const { sequelize } = require('../models');

const getTotalSoldByCategory = async (req, res, next) => {
  try {
    const dialect = sequelize.getDialect();
    const categoryNameColumn = dialect === 'postgres' ? 'c."NAME"' : 'c.NAME';

    const query = `
      SELECT
        c.id,
        ${categoryNameColumn} AS category,
        COALESCE(SUM(oi.subtotal), 0) AS total_sold
      FROM categories c
      LEFT JOIN products p ON p.category_id = c.id
      LEFT JOIN order_items oi ON oi.product_id = p.id
      GROUP BY c.id, ${categoryNameColumn}
      ORDER BY c.id
    `;

    const [rows] = await sequelize.query(query);

    return res.json({
      engine: dialect,
      data: rows
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  getTotalSoldByCategory
};