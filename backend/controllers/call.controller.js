const Call = require("../models/calls.model");
const moment = require("moment-timezone"); // Use moment-timezone for handling IST

const addcall = async (req, res) => {
  const { phone, name } = req.body;
  console.log(req.body);
  try {
    const call = await Call.create({
      phone,
      name,
    });
    res.status(200).json({
      message: "call added",
      call,
    });
  } catch (error) {
    res.status(400).json({
      message: "call not added",
      error,
    });
    console.log(error);
  }
};

const getcallsforadmin = async (req, res) => {
  try {
    const calls = await Call.findAll();
    res.status(200).json({
      message: "success",
      calls,
    });
  } catch (error) {
    res.status(400).json({
      message: " error fetcuhing calls",
      error,
    });
    console.log(error);
  }
};

const getcallsforuser = async (req, res) => {
  try {
    const userId = req.user.id;
    console.log(userId);
    const currentISTTime = moment().tz("Asia/Kolkata");
    const startISTTime = moment()
      .tz("Asia/Kolkata")
      .set({ hour: 9, minute: 0 });
    const endISTTime = moment().tz("Asia/Kolkata").set({ hour: 5, minute: 0 });
    // if (
    //   currentISTTime.isBefore(startISTTime) ||
    //   currentISTTime.isAfter(endISTTime)
    // ) {
    //   return res.status(400).json({
    //     message: "You can only request call data between 9 AM and 11 AM IST.",
    //   });
    // }

    // Find all calls assigned to the user that are uncompleted
    const uncompletedCalls = await Call.findAll({
      where: {
        assignedto: userId, // Calls assigned to this user
        status: "uncompleted", // Assuming 'status' field exists for call completion
      },
      limit: 100, // Fetch a limit of 100 uncompleted calls
    });
    console.log(uncompletedCalls, "uncompletedCalls");
    // If all calls are completed, fetch a new set of 100 calls
    if (uncompletedCalls.length === 0) {
      const newCalls = await Call.findAll({
        where: {
          status: "uncompleted", // Fetch uncompleted calls for reassignment
          assignedto: null, // Calls not assigned to any user yet
        },
        limit: 100,
      });

      // Assign new calls to the user
      for (let call of newCalls) {
        call.assignedto = userId;
        await call.save(); // Save the updated call data
      }
      console.log(newCalls, "newCalls");
      return res.status(200).json({
        message: "success.",
        calls: newCalls,
      });
    }

    // Return the existing uncompleted calls for the user
    res.status(200).json({
      message: "success",
      calls: uncompletedCalls,
    });
  } catch (error) {
    res.status(400).json({
      message: " error fetcuhing calls",
      error,
    });
    console.log(error);
  }
};

const addcallstatus = async (req, res) => {
  const userId = req.user.id;
  const { callId, phoneNumber, result, projectName } = req.body;
  console.log(req.body);
  try {
    const call = await Call.findOne({
      where: {
        id: callId,
        phone: phoneNumber,
        assignedto: userId,
      },
    });
    console.log("===>", call);
    if (!call) {
      return res.status(404).json({ message: "Call not found" });
    }
    call.projectname = projectName;
    call.status = result;
    await call.save();

    res.status(200).json({
      message: "Call status updated successfully",
      call,
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({
      message: "Error updating call status",
      error: error.message,
    });
  }
};

const getleads = async (req, res) => {
  const userId = req.user.id;
  try {
    const leads = await Call.findAll({
      where: {
        status: "interested",
        assignedto: userId,
      },
    });
    console.log(leads, "leads");
    res.status(200).json({
      message: "success",
      leads,
    });
  } catch (error) {
    res.status(400).json({
      message: " error fetcuhing calls",
      error,
    });
    console.log(error);
  }
};

module.exports = {
  addcall,
  getcallsforadmin,
  getcallsforuser,
  addcallstatus,
  getleads,
};
