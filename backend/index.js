require("dotenv").config();

const express = require("express");

const app = express();

const cors = require("cors");
app.use(cors());

app.use(express.json());
app.use("/api", require("./routes/auth.route"));
app.use("/api", require("./routes/call.route"));

// app.use("/api", require("./routes/externalapi"));
// app.use("/api", require("./routes/fileupload.route"));
// app.use("/api", require("./routes/ovul.route"));
// app.use("/api", require("./routes/doctor.route"));
// app.use("/api", require("./routes/food.route"));

app.get("/", (req, res) => {
  res.json("hello from bacekned");
});

const port = 8080 || process.env.PORT;
app.listen(port, () => {
  console.log(`server started at ${port}`);
});

module.exports = app;
