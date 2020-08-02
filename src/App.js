import React from 'react';
import logo from './logo.svg';
import './App.css';
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
 
import { SplashMain } from './splashmain';
import { DetailsMain } from './details/detailsmain';

//  Get shared variables
let API_URL = process.env.REACT_APP_API_URL; API_URL= (API_URL == null ? 'http://localhost:3000' : API_URL);
let GA_KEY = process.env.REACT_APP_GA_KEY; GA_KEY = (GA_KEY == null ? 'n/a' : GA_KEY);


class App extends React.Component {

  constructor() {
    super();
  }

  state = {  
      userDetails: null,
      userScreenName: null
  }

  // Set user, user screen name (in state)
  handleSetUserDetails = (userDetails) => {
    console.log('setting user to: {userScreen}');
    this.setState({
      userDetails: userDetails,
      userScreenName: userDetails['user']['screen_name']
    })
  };

  //  Clear user in state 
  handleClearUser = () => {
    this.setState({
      userDetails: null,
      userScreenName: null,
    })
  }

  //  Get current user / details
  activeUserDetails = () => { return(this.state.userDetails); }
  activeScreenName  = () => { return(this.state.userScreenName); }

  render() {
    return(
      <Router>
        <div>
          <Switch>
            <Route exact={true} path="/"
              render={() => <SplashMain handleSetUserDetails={this.handleSetUserDetails} 
                                        handleClearUser={this.handleClearUser} /> } />
            <Route exact={true} path="/details" 
              render={() => <DetailsMain handleClearUser={this.handleClearUser}  
                                         activeUserDetails={this.activeUserDetails} 
                                         activeScreenName={this.activeScreenName}  /> } />
          </Switch>
        </div>
      </Router>
    );
  }
}

export { API_URL, GA_KEY };
export default App;