import React from 'react';
import logo from './logo.svg';
import './App.css';
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';

import { Button, Spinner, Form, OverlayTrigger, 
    Tooltip, Container, Row, Col, Navbar, 
    FormControl, Jumbotron, Popover } from 'react-bootstrap';
    

class SplashMain extends React.Component
{
    //  -- Event handlers, from App (parent container) --
    //      this.props.handleUseDetails
    //      this.props.handleClearUser

    state = {
        inputScreenName: '',    // store form entry value
        hasError: false,        // if true, will render error message
        validUserFound: false   // if true, will redirect to details page
    };

    // Handle user search / submit
    handleSubmit = async(event) => {
        this.setState({hasError: false}); // Ensure clean slate on error
        event.preventDefault();  // do not refresh page (as this is invoked via submit button)
        const userScreenName = event.target.elements.screen_name.value;
        // -- todo: add GA event
        const resp = await axios.get(`http://localhost:5000/api/user/`, {params: {screen_name: userScreenName}});

        //  Handle Response
        if ('error' in resp.data && resp.data.error)  {
            //  In event of error, set state, and render error message
            this.setState({hasError: true});
        }
        else {
            //  Valid response / user found:  set to master state, redirect to details page
            const handleSetUserDetails = this.props.handleSetUserDetails;
            handleSetUserDetails(resp.data);
            this.setState({validUserFound: true});
        }
    };

    //  Sync user input to state
    handleInputChange = (event) => {
        this.setState({inputScreenName: event.target.value});
    };

    render() {

        // Set handlers for user profile management
        const handleSetUserDetails = this.props.handleSetUserDetails;
        const handleClearUser = this.props.handleClearUser;
        
        if (this.state.validUserFound) 
        {
            console.log('valid user found.  sending to details');
            return(
                <Redirect push to={{pathname: '/details'}}/>
            );
        }

        return(
            <div>
                <Form inline onSubmit={this.handleSubmit} method="get">
                    <FormControl type="text" placeholder="Enter Twitter Username" className="mr-md-2" name="screen_name" 
                                 onChange={this.handleInputChange}/>
                    <Button variant="outline-primary" type="submit">Find User</Button>
                </Form>
                <font color='red'>{this.state.hasError ? 'User not found' : ''}</font>
            </div>
        );
    }

}

export { SplashMain };