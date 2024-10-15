require("dotenv").config();
const jwt = require("jsonwebtoken");
const XLSX = require("xlsx");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");

const User = require("../models/user.model");

const logincontroller = async (req, res) => {
  const { employeeId, password } = req.body;
  console.log(req.body);
  let user = await User.findOne({ employeeId });

  if (!user) {
    return res.status(200).json({ message: "ACCOUNT DOES'NOT EXISTS" });
  }

  const passmatch = await bcrypt.compare(password, user.password);
  if (!passmatch) {
    return res.status(200).json({ message: "wrong password" });
  }

  const token = jwt.sign({ id: user.id }, "randomtoken", {
    expiresIn: "10d",
  });

  const userResponse = {
    id: user.id,
    employeeId: user.employeeId,
    name: user.name,
    email: user.email,
    phone: user.phone,
    role: user.role,
  };

  return res
    .status(200)
    .json({ message: "success", token, user: userResponse });
};

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const createuserusingexcel = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const workbook = XLSX.read(req.file.buffer, { type: "buffer" });
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(sheet);

    const createdUsers = [];

    for (const row of data) {
      const {
        "Employee Id": employeeId,
        Name: name,
        "Mobile Number": phone,
        "Email Id": email,
      } = row;
      const password = Math.floor(
        10000000 + Math.random() * 90000000
      ).toString();
      const hashedPassword = await bcrypt.hash(password, 10);

      const newUser = await User.create({
        employeeId,
        name,
        phone,
        email,
        password: hashedPassword,
      });
      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: email,
        subject: "Your login Details - (testing) for website",
        text: `Your employee ID is: ${employeeId}\nYour temporary password is: ${password}\nPlease change your password after first login.`,
      };
      await transporter.sendMail(mailOptions);

      createdUsers.push({
        employeeId: newUser.employeeId,
        name: newUser.name,
        email: newUser.email,
        password: password, // Note: This is the unhashed password
      });
    }

    res.status(200).json({
      message: "Users created successfully",
      users: createdUsers,
    });
  } catch (error) {
    console.error("Error creating users from Excel:", error);
    res
      .status(500)
      .json({ message: "Error creating users", error: error.message });
  }
};

const userdetail = async (req, res) => {
  console.log("line 30");
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ["password", "updatedAt", "createdAt"] },
    });
    console.log(user);
    res.status(200).json({
      user,
    });
  } catch (error) {
    console.log("here", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// const send_verification_code = async (req, res) => {
//   const { phoneNumber } = req.body;
//   console.log(phoneNumber);
//   try {
//     const verificationCode = generateRandom5DigitNumber();
//     if (phoneNumber) {
//       await sendSMS(phoneNumber, verificationCode);
//     }

//     // const otps = await new Allotp({
//     //     otp: verificationCode,
//     //     phoneNumber: phoneNumber
//     // })
//     // await otps.save();
//     const otps = await Otp.create({
//       otp: verificationCode,
//       phoneNumber: phoneNumber,
//     });

//     console.log(verificationCode);
//     res.status(200).json({ message: "Verification code sent successfully" });
//   } catch (err) {
//     console.log("some error occured", err);
//     res.status(400).json({ error: "Verification code not sent" });
//   }
// };

// const verify_otp = async (req, res) => {
//   const { otp, phoneNumber } = req.body;

//   console.log(phoneNumber);
//   // Ensure phone number is in the expected format (you might need a more robust validation here)
//   // const phoneRegex = /^\d{10}$/;
//   // if (!phoneRegex.test(phoneNumber)) {
//   //   return res.status(400).json({ error: "Invalid phone number format" });
//   // }

//   if (otp) {
//     try {
//       // Sequelize equivalent to findOne
//       const check = await Otp.findOne({
//         where: { otp },
//       });

//       if (check) {
//         let user = await User.findOne({
//           where: { phone: phoneNumber },
//         });

//         if (!user) {
//           user = await User.create({ phone: phoneNumber });
//         }

//         // Generate JWT token
//         const token = jwt.sign({ id: user.id, phoneNumber }, "secretKey", {
//           expiresIn: "5d",
//         });

//         // Sequelize equivalent to findOne

//         return res.status(200).json({
//           token,
//           user,
//           phoneNumber,
//           profileupdated: user.name ? true : false,
//         });
//       }

//       return res.status(400).json({ error: "Wrong Verification OTP" });
//     } catch (error) {
//       console.error("Error during OTP verification:", error);
//       return res.status(500).json({ error: "Internal server error" });
//     }
//   } else {
//     return res.status(400).json({ error: "Missing OTP" });
//   }
// };

// const addprofile = async (req, res) => {
//   const { name, gender, dob, profielimageindex, weight, height, bmi, bmr } =
//     req.body;
//   console.log(req.body);

//   const userId = req.user.id;
//   console.log(req.body, userId);
//   try {
//     if (name || gender) {
//       const result = await User.update(
//         {
//           name: name,
//           gender: gender,
//           dob,
//           profileavatarindex: profielimageindex,
//           weight,
//           height,
//           bmi,
//           bmr,
//         }, // Fields to update
//         {
//           where: { id: userId }, // Update condition
//         }
//       );
//     } else {
//       return res.status(400).json({
//         success: "Missing values name and gender",
//       });
//     }

//     const user = await User.findByPk(req.user.id, {
//       attributes: { exclude: ["password", "updatedAt", "createdAt"] },
//     });
//     console.log(user);
//     res.status(200).json({
//       success: "Updated successfully",
//       user,
//     });
//   } catch (err) {
//     console.log(err);
//     res.status(500).json({ error: "Some error occured" });
//   }
// };

// const markaspro = async (req, res) => {
//   const userId = req.user.id;
//   try {
//     const user = await User.findByPk(userId);
//     if (user) {
//       user.ispro = true;
//       await user.save();
//       res.status(200).json({
//         success: "User marked as pro",
//       });
//     } else {
//       res.status(404).json({
//         error: "User not found",
//       });
//     }
//   } catch (err) {
//     console.log(err);
//     res.status(500).json({ error: "Some error occured" });
//   }
// };

module.exports = {
  logincontroller,
  createuserusingexcel,
  userdetail,
  // send_verification_code,
  // verify_otp,
  // addprofile,
  // markaspro,
};
