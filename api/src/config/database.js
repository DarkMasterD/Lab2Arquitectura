require('dotenv').config();

const { Sequelize } = require('sequelize');

const dialect = (process.env.DB_DIALECT || 'mysql').toLowerCase();
const defaultPort = dialect === 'postgres' ? 5433 : 3307;

const sequelize = new Sequelize(
  process.env.DB_NAME || process.env.MYSQL_DATABASE || process.env.POSTGRES_DB || 'ecom_db',
  process.env.DB_USER || process.env.MYSQL_USER || process.env.POSTGRES_USER || 'root',
  process.env.DB_PASSWORD || process.env.MYSQL_PASSWORD || process.env.POSTGRES_PASSWORD || '',
  {
    host: process.env.DB_HOST || '127.0.0.1',
    port: Number(process.env.DB_PORT || defaultPort),
    dialect,
    logging: false,
    define: {
      freezeTableName: true,
      underscored: true,
      timestamps: false
    }
  }
);

module.exports = sequelize;