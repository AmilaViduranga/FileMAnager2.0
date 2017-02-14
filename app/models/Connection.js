var Sequelize = require('sequelize');

var sequelize = require('sequelize')
    , sequelize = new Sequelize('tutorwizard', 'root', ' ', {
      dialect: "mysql",
      port:    3306,
      host: '192.168.1.51',
      dialectOptions: {
        multipleStatements: true
      }
    });

module.exports = sequelize;

