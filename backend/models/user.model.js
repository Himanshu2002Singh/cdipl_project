const { DataTypes, INTEGER, STRING } = require("sequelize");
const sequelize = require("../config/database");
// const generateUniqueId = () => {
//   const prefix = "CDIPL"; // Your custom prefix
//   const randomSuffix = Math.floor(1000 + Math.random() * 9000); // Random number between 1000 and 9999
//   return `${prefix}${randomSuffix}`; // Combine prefix and random number
// };

const User = sequelize.define("User", {
  // id: {
  //   type: DataTypes.STRING,
  //   primaryKey: true,
  //   defaultValue: generateUniqueId,
  // },
  employeeId: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
  },
  phone: { type: DataTypes.BIGINT },
  name: { type: DataTypes.STRING },
  password: { type: DataTypes.STRING },
  email: { type: DataTypes.STRING },
  points: { type: DataTypes.INTEGER, defaultValue: 0 },
  // roleId: {
  //   type: DataTypes.INTEGER,
  //   defaultValue: 3,
  //   allowNull: false,
  //   references: {
  //     model: "Roles",
  //     key: "id",
  //   },
  // },

  role: {
    type: DataTypes.STRING,
    defaultValue: "user",
    enum: ["user", "admin", "superadmin"],
  },
  // meallist: { type: DataTypes.JSON, allowNull: true },
});

// User.associate = (models) => {
//   User.belongsTo(models.Role, {
//     foreignKey: "roleId",
//     as: "role",
//   });
// };

// User.sync({ force: false })
User.sync({ force: false })

  .then(() => {
    console.log("User table created");
  })
  .catch((error) => {
    console.error("Error creating User table:", error);
  });

module.exports = User;
