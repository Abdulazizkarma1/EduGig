import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link
} from "react-router-dom";

import Home from './pages/Home';
import Learn from './pages/Learn';
import Gigs from './pages/Gigs';
import Profile from './pages/Profile';
import Validator from './pages/Validator';

const App = () => {
  return (
    <Router>
      <div>
        <nav className="bg-white shadow-md">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between h-16">
              <div className="flex items-center">
                <Link to="/" className="text-2xl font-bold text-gray-800">EduGig</Link>
              </div>
              <div className="hidden md:block">
                <div className="ml-10 flex items-baseline space-x-4">
                  <Link to="/learn" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">Learn</Link>
                  <Link to="/gigs" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">Gigs</Link>
                  <Link to="/profile" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">Profile</Link>
                  <Link to="/validator" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">Validator</Link>
                </div>
              </div>
            </div>
          </div>
        </nav>

        <main>
          <Routes>
            <Route path="/learn" element={<Learn />} />
            <Route path="/gigs" element={<Gigs />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="/validator" element={<Validator />} />
            <Route path="/" element={<Home />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
};

export default App;
