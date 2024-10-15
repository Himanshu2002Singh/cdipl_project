import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  useLocation,
} from "react-router-dom";
import Login from "./auth/login";
import Home from "./home";
import Sidebar from "./components/sidebar";
import AddColdCall from "./calls/addColdCall";
import CallList from "./calls/Screens/calllist";
import UserList from "./users/Screens/userlist";
import UserListtoassign from "./assigntask/Screens/userlisttoassign";

// Custom layout component that uses useLocation hook
const Layout = () => {
  const location = useLocation();
  const noSidebarRoutes = ["/login", "/signup"];

  return (
    <div className="flex">
      {/* Conditionally render Sidebar */}
      {!noSidebarRoutes.includes(location.pathname) && <Sidebar />}
      <div
        className={`flex-1 p-6 ${
          !noSidebarRoutes.includes(location.pathname) ? "ml-64" : ""
        }`}
      >
        <Routes>
          <Route exact path="/" element={<Home />} />
          <Route exact path="/login" element={<Login />} />
          <Route exact path="/add-cold-call" element={<CallList />} />
          <Route exact path="/add-users" element={<UserList />} />
          <Route exact path="/assign-task" element={<UserListtoassign />} />

          {/* Add more routes as needed */}
        </Routes>
      </div>
    </div>
  );
};

function App() {
  return (
    <Router>
      <Layout />
    </Router>
  );
}

export default App;
