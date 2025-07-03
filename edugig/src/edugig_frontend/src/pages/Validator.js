import React, { useState, useEffect } from 'react';
import { edugig_backend } from '../../../../declarations/edugig_backend';

const Validator = () => {
  const [submissions, setSubmissions] = useState([]);

  useEffect(() => {
    const fetchSubmissions = async () => {
      // This is a placeholder. We need a way to list submissions for the validator.
      // const submissionList = await edugig_backend.listSubmissions();
      // setSubmissions(submissionList);
    };
    fetchSubmissions();
  }, []);

  const handleApprove = async (id) => {
    await edugig_backend.approveSubmission(id);
    // Refresh the list
  };

  const handleReject = async (id) => {
    await edugig_backend.rejectSubmission(id);
    // Refresh the list
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-gray-800">Validator Dashboard</h1>
      <div className="mt-6">
        {submissions.map((submission) => (
          <div key={submission.id} className="bg-white p-4 rounded-lg shadow-md mb-4">
            <p><span className="font-bold">Submission ID:</span> {submission.id}</p>
            <p><span className="font-bold">Task ID:</span> {submission.taskId}</p>
            <p><span className="font-bold">Content:</span> {submission.content}</p>
            <p><span className="font-bold">Status:</span> {Object.keys(submission.status)[0]}</p>
            <div className="mt-4">
              <button onClick={() => handleApprove(submission.id)} className="bg-green-500 text-white px-4 py-2 rounded-md mr-2">Approve</button>
              <button onClick={() => handleReject(submission.id)} className="bg-red-500 text-white px-4 py-2 rounded-md">Reject</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Validator;
