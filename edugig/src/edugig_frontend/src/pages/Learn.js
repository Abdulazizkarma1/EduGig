import React, { useState, useEffect } from 'react';
import { edugig_backend } from '../../../../declarations/edugig_backend';

const Learn = () => {
  const [modules, setModules] = useState([]);

  useEffect(() => {
    const fetchModules = async () => {
      const moduleList = await edugig_backend.listModules();
      setModules(moduleList);
    };
    fetchModules();
  }, []);

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-gray-800">Learning Modules</h1>
      <div className="mt-6 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {modules.map((module) => (
          <div key={module.id} className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-xl font-bold text-gray-800">{module.title}</h2>
            <p className="mt-2 text-gray-600">{module.content}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Learn;
