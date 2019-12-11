import React, { useState } from 'react';
import {
  HashRouter as Router,
  Switch,
  Route,
  Link
} from "react-router-dom";
import { ShortenPage } from "./pages/ShortenPage"
import { StatisticsPage } from "./pages/StatisticsPage"


function App() {
  return (
    <div className="App">
      <Router>
        <Switch>
          <Route exact path="/">
            <ShortenPage />
          </Route>
          <Route path="/statistics">
            <StatisticsPage />
          </Route>
        </Switch>
      </Router>
    </div>
  );
}

export default App;
