import React from 'react';
import logo from './logo.svg';
import './App.css';
import { Route, BrowserRouter as Router, Switch } from 'react-router-dom';
import { SplashMain } from './splashmain';
import { DetailsMain } from './details/detailsmain';
import axios from 'axios';


//  Get shared variables
let API_URL = process.env.REACT_APP_API_URL; API_URL = (API_URL == null ? 'http://localhost:5000' : API_URL);
let GA_KEY = process.env.REACT_APP_GA_KEY; GA_KEY = (GA_KEY == null ? 'n/a' : GA_KEY);


class App extends React.Component {

  constructor() {
    super();
    this.initScreenMeta();
  }

  state = {  
      userDetails: null,
      userScreenName: null,
      screenMeta: {}
  }

  //  Get screen meta info, init to state
  initScreenMeta = async(event) => {
    if (Object.keys(this.state.screenMeta).length > 0)
        return;
    const resp = await axios.get(`${API_URL}/api/screenmeta/`);
    this.setState({screenMeta: resp.data});
  }


  // Set user, user screen name (in state)
  handleSetUserDetails = (userDetails) => {
    console.log(`setting user to: ${userDetails['user']['screen_name']}`);
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


  render() {
    return(
        <Router>
            <Switch>
              <Route exact={true} path="/"
                render={() => <SplashMain handleSetUserDetails={this.handleSetUserDetails} 
                                          handleClearUser={this.handleClearUser}
                                          screenMeta={this.state.screenMeta} /> } />
              <Route exact={true} path="/details" 
                render={() => <DetailsMain handleClearUser={this.handleClearUser}  
                                           userDetails={this.state.userDetails}
                                           userScreenName={this.state.userScreenName}
                                           screenMeta={this.state.screenMeta}/> } />
            </Switch>
        </Router>
    );
  }
}

export { API_URL, GA_KEY };
export default App;