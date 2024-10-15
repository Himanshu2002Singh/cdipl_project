function checkRole(allowedRoles) {
  return (req, res, next) => {
    const userRole = req.user.role.name;
    if (allowedRoles.includes(userRole)) {
      return next();
    }
    return res.status(403).json({ message: "Access denied" });
  };
}

module.exports = checkRole;
