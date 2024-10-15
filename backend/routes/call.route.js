const express = require("express");
const callcontroller = require("../controllers/call.controller");
const router = express.Router();
const auth = require("../middlewares/isAuthenticated");

router.post("/addcall", callcontroller.addcall);
router.get("/getcoldcall", callcontroller.getcallsforadmin);
router.get(
  "/getcoldcall/user",
  auth.isAuthenticated,
  callcontroller.getcallsforuser
);

router.patch(
  "/update/callstatus",
  auth.isAuthenticated,
  callcontroller.addcallstatus
);

router.get("/get/myleads", auth.isAuthenticated, callcontroller.getleads);

// router.post("/send_verification_code", authentication.send_verification_code);
// router.post("/verify-otp", authentication.verify_otp);
// router.post("/profile-detail", auth.isAuthenticated, authentication.addprofile);

// router.get("/userdetail", auth.isAuthenticated, authentication.userdetail);

// router.get("/payment-success", auth.isAuthenticated, authentication.markaspro);
// router.get('/superadmin', checkRole(['superadmin']), (req, res) => {
//     res.send('Hello Superadmin');
//   });

module.exports = router;
