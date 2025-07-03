import React from 'react';
import { createRoot } from 'react-dom/client';
import '../assets/main.css';

const App = () => (
  <div className="min-h-screen bg-gray-100 flex flex-col items-center justify-center">
    <h1 className="text-5xl font-extrabold text-center text-gray-800">
      Welcome to EduGig
    </h1>
    <p className="mt-4 text-lg text-gray-600">
      Your journey to master tech skills begins here.
    </p>
  </div>
);


const container = document.getElementById('root');
const root = createRoot(container);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
