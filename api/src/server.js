const app = require('./app');
const { sequelize } = require('./models');

const port = Number(process.env.PORT || 3000);

const start = async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexión a la base de datos establecida');

    app.listen(port, () => {
      console.log(`API escuchando en el puerto ${port}`);
    });
  } catch (error) {
    console.error('No fue posible conectar a la base de datos:', error.message);
    process.exit(1);
  }
};

start();