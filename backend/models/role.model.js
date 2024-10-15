// const User = require("./user.model");

// module.exports = (sequelize, DataTypes) => {
//   const Role = sequelize.define("Role", {
//     id: {
//       type: DataTypes.INTEGER,
//       primaryKey: true,
//       autoIncrement: true,
//     },
//     name: {
//       type: DataTypes.STRING,
//       allowNull: false,
//     },
//   });

//   Role.associate = (models) => {
//     Role.hasMany(models.User, {
//       foreignKey: "roleId",
//       as: "users",
//     });
//   };
//   Role.sync({ alter: true })
//     .then(() => {
//       return User.sync({ alter: true });
//     })
//     .then(() => {
//       console.log("User table created");
//     })
//     .catch((error) => {
//       console.error("Error creating tables:", error);
//     });

//   return Role;
// };
