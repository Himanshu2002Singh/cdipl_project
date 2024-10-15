const { DataTypes, INTEGER, STRING, TEXT } = require("sequelize");
const sequelize = require("../config/database");
const Call = sequelize.define("Call", {
  phone: { type: DataTypes.BIGINT },
  name: { type: DataTypes.STRING },
  assignedto: { type: DataTypes.STRING },
  status: {
    type: DataTypes.STRING,
    allowNull: true,
    defaultValue: "uncompleted",
    enum: ["interested", "not interested", "future", "uncompleted"],
  },
  projectname: { type: DataTypes.TEXT, allowNull: true },
  futuredate: { type: DataTypes.STRING, allowNull: true },
  // meallist: { type: DataTypes.JSON, allowNull: true },
});
Call.sync({ force: false })

  .then(() => {
    console.log("Call table created");
  })
  .catch((error) => {
    console.error("Error creating Call table:", error);
  });

module.exports = Call;
