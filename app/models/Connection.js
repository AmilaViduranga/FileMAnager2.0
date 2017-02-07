var Sequelize = require('sequelize');

var sequelize = require('sequelize')
    , sequelize = new Sequelize('tutorwizard', 'root', '', {
      dialect: "mysql",
      port:    3306,
      host: 'localhost',
      dialectOptions: {
        multipleStatements: true
      }
    })
    ;

module.exports = sequelize;

