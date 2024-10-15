import React, { useState } from "react";
import AddColdCall from "../addColdCall";
import AddColdCallExcel from "../addColdCallExcel";

const UserListtoassign = () => {
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isExcelModalOpen, setIsExcelModalOpen] = useState(false);

  const users = [
    {
      id: 1,
      name: " Doe",
      email: "john@example.com",
      role: "Admin",
      joinedAt: "2022-05-15",
    },
    {
      id: 2,
      name: "Jane Smith",
      email: "jane@example.com",
      role: "User",
      joinedAt: "2022-07-20",
    },
    {
      id: 3,
      name: "Alen Doe",
      email: "alen@example.com",
      role: "User",
      joinedAt: "2022-07-21",
    },
    // Add more users here
  ];

  const handleopenaddcallformModal = () => {
    setIsFormModalOpen(true);
  };

  const handleCloseaddcallformModal = () => {
    setIsFormModalOpen(false);
  };

  const handleopenaddcallExcelModal = () => {
    setIsExcelModalOpen(true);
  };

  const handleCloseaddcallExcelModal = () => {
    setIsExcelModalOpen(false);
  };

  return (
    <div>
      {isFormModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
          {" "}
          <div className=" p-6 rounded w-1/3">
            <AddColdCall
              handleCloseaddcallformModal={handleCloseaddcallformModal}
            />
          </div>
        </div>
      )}
      {isExcelModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
          {" "}
          <div className=" p-6 rounded w-1/3">
            <AddColdCallExcel
              handleCloseaddcallExcelModal={handleCloseaddcallExcelModal}
            />
          </div>
        </div>
      )}

      <div className="font-sans overflow-x-auto">
        {" "}
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold">User List</h2>
          {/* <div> */}
          {/* <button
              onClick={handleopenaddcallformModal}
              className="mr-2 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-700"
            >
              Assign Task
            </button> */}
          {/* <button
              onClick={handleopenaddcallExcelModal}
              className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-700"
            >
              Upload using Excel
            </button> */}
          {/* </div> */}
        </div>
        <table className="min-w-full bg-white">
          <thead className="bg-gray-100 whitespace-nowrap">
            <tr>
              <th className="p-4 text-left text-xs font-semibold text-gray-800">
                Name
              </th>
              <th className="p-4 text-left text-xs font-semibold text-gray-800">
                Email
              </th>
              <th className="p-4 text-left text-xs font-semibold text-gray-800">
                Role
              </th>
              <th className="p-4 text-left text-xs font-semibold text-gray-800">
                Joined At
              </th>
              <th className="p-4 text-left text-xs font-semibold text-gray-800">
                Actions
              </th>
            </tr>
          </thead>

          <tbody className="whitespace-nowrap">
            {users.map((user) => (
              <tr key={user.id} className="hover:bg-gray-50">
                <td className="p-4 text-[15px] text-gray-800">{user.name}</td>
                <td className="p-4 text-[15px] text-gray-800">{user.email}</td>
                <td className="p-4 text-[15px] text-gray-800">{user.role}</td>
                <td className="p-4 text-[15px] text-gray-800">
                  {user.joinedAt}
                </td>
                <td className="p-4">
                  <button
                    class="mr-4"
                    title="Edit"
                    onClick={handleopenaddcallformModal}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="w-5 fill-blue-500 hover:fill-blue-700"
                      viewBox="0 0 348.882 348.882"
                    >
                      <path
                        d="m333.988 11.758-.42-.383A43.363 43.363 0 0 0 304.258 0a43.579 43.579 0 0 0-32.104 14.153L116.803 184.231a14.993 14.993 0 0 0-3.154 5.37l-18.267 54.762c-2.112 6.331-1.052 13.333 2.835 18.729 3.918 5.438 10.23 8.685 16.886 8.685h.001c2.879 0 5.693-.592 8.362-1.76l52.89-23.138a14.985 14.985 0 0 0 5.063-3.626L336.771 73.176c16.166-17.697 14.919-45.247-2.783-61.418zM130.381 234.247l10.719-32.134.904-.99 20.316 18.556-.904.99-31.035 13.578zm184.24-181.304L182.553 197.53l-20.316-18.556L294.305 34.386c2.583-2.828 6.118-4.386 9.954-4.386 3.365 0 6.588 1.252 9.082 3.53l.419.383c5.484 5.009 5.87 13.546.861 19.03z"
                        data-original="#000000"
                      />
                      <path
                        d="M303.85 138.388c-8.284 0-15 6.716-15 15v127.347c0 21.034-17.113 38.147-38.147 38.147H68.904c-21.035 0-38.147-17.113-38.147-38.147V100.413c0-21.034 17.113-38.147 38.147-38.147h131.587c8.284 0 15-6.716 15-15s-6.716-15-15-15H68.904C31.327 32.266.757 62.837.757 100.413v180.321c0 37.576 30.571 68.147 68.147 68.147h181.798c37.576 0 68.147-30.571 68.147-68.147V153.388c.001-8.284-6.715-15-14.999-15z"
                        data-original="#000000"
                      />
                    </svg>
                  </button>
                  <button
                    class="mr-4"
                    title="Delete"
                    onClick={handleopenaddcallExcelModal}
                  >
                    <svg
                      fill="#000000"
                      height="20px"
                      width="20px"
                      version="1.1"
                      id="Layer_1"
                      xmlns="http://www.w3.org/2000/svg"
                      xmlns:xlink="http://www.w3.org/1999/xlink"
                      viewBox="0 0 512 512"
                      xml:space="preserve"
                    >
                      <g>
                        <g>
                          <g>
                            <path
                              d="M447.168,134.56c-0.535-1.288-1.318-2.459-2.304-3.445l-128-128c-2.003-1.988-4.709-3.107-7.531-3.115H74.667
				C68.776,0,64,4.776,64,10.667v490.667C64,507.224,68.776,512,74.667,512h362.667c5.891,0,10.667-4.776,10.667-10.667V138.667
				C447.997,137.256,447.714,135.86,447.168,134.56z M320,36.416L411.584,128H320V36.416z M426.667,490.667H85.333V21.333h213.333
				v117.333c0,5.891,4.776,10.667,10.667,10.667h117.333V490.667z"
                            />
                            <path
                              d="M128,181.333v256c0,5.891,4.776,10.667,10.667,10.667h234.667c5.891,0,10.667-4.776,10.667-10.667v-256
				c0-5.891-4.776-10.667-10.667-10.667H138.667C132.776,170.667,128,175.442,128,181.333z M320,192h42.667v42.667H320V192z
				 M320,256h42.667v42.667H320V256z M320,320h42.667v42.667H320V320z M320,384h42.667v42.667H320V384z M213.333,192h85.333v42.667
				h-85.333V192z M213.333,256h85.333v42.667h-85.333V256z M213.333,320h85.333v42.667h-85.333V320z M213.333,384h85.333v42.667
				h-85.333V384z M149.333,192H192v42.667h-42.667V192z M149.333,256H192v42.667h-42.667V256z M149.333,320H192v42.667h-42.667V320z
				 M149.333,384H192v42.667h-42.667V384z"
                            />
                          </g>
                        </g>
                      </g>
                    </svg>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default UserListtoassign;
