import React, { useState, useEffect } from 'react';
import { edugig_backend } from '../../../../declarations/edugig_backend';
import { AuthClient } from "@dfinity/auth-client";

const Profile = () => {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const fetchUser = async () => {
      const authClient = await AuthClient.create();
      const identity = await authClient.getIdentity();
      const principal = identity.getPrincipal();
      const userProfile = await edugig_backend.getUser(principal);
      setUser(userProfile);
    };
    fetchUser();
  }, []);

  return (
    <div className="container mx-auto px-4 py-8">
      {user ? (
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Profile</h1>
          <div className="mt-6">
            <p><span className="font-bold">Name:</span> {user.name}</p>
            <p><span className="font-bold">Role:</span> {Object.keys(user.role)[0]}</p>
          </div>
          <h2 className="mt-8 text-2xl font-bold text-gray-800">Badges</h2>
          <div className="mt-4 grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {user.badges.map((badge) => (
              <div key={badge.id} className="bg-white p-4 rounded-lg shadow-md">
                <p><span className="font-bold">Task ID:</span> {badge.taskId}</p>
                <p><span className="font-bold">Date:</span> {new Date(Number(badge.date) / 1000000).toLocaleDateString()}</p>
              </div>
            ))}
          </div>
        </div>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
};

export default Profile;
