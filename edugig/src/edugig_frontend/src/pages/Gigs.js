import React, { useState, useEffect } from 'react';
import { edugig_backend } from '../../../../declarations/edugig_backend';

const Gigs = () => {
  const [tasks, setTasks] = useState([]);

  useEffect(() => {
    const fetchTasks = async () => {
      const taskList = await edugig_backend.listTasks();
      setTasks(taskList);
    };
    fetchTasks();
  }, []);

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-gray-800">Available Gigs</h1>
      <div className="mt-6 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {tasks.map((task) => (
          <div key={task.id} className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-xl font-bold text-gray-800">{task.title}</h2>
            <p className="mt-2 text-gray-600">{task.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Gigs;
