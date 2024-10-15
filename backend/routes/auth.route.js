const express = require("express");
const authentication = require("../controllers/auth.controller");
const router = express.Router();
const auth = require("../middlewares/isAuthenticated");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

router.post("/login", authentication.logincontroller);
router.post(
  "/createuserusingexcel",
  upload.single("file"),
  authentication.createuserusingexcel
);

// router.post("/send_verification_code", authentication.send_verification_code);
// router.post("/verify-otp", authentication.verify_otp);
// router.post("/profile-detail", auth.isAuthenticated, authentication.addprofile);

router.get("/userdetail", auth.isAuthenticated, authentication.userdetail);

// router.get("/payment-success", auth.isAuthenticated, authentication.markaspro);
// router.get('/superadmin', checkRole(['superadmin']), (req, res) => {
//     res.send('Hello Superadmin');
//   });

module.exports = router;
