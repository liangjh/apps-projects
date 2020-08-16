import React from 'react';
import logo from './logo.svg';
import './App.css';
import { API_URL, GA_KEY } from './App'
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import ReactGA from 'react-ga';

import { Button, Spinner, Form, OverlayTrigger, 
    Tooltip, Container, Row, Col, Navbar, 
    FormControl, Jumbotron, Popover } from 'react-bootstrap';
    
// Initialize GA component
ReactGA.initialize(GA_KEY);

class SplashMain extends React.Component {

    //  -- Event handlers, from App (parent container) --
    //      this.props.handleUseDetails
    //      this.props.handleClearUser

    state = {
        inputScreenName: '',    // store form entry value
        hasError: false,        // if true, will render error message
        validUserFound: false,  // if true, will redirect to details page
        loading: false
    };

    // Spinner for all submissions
    spinnerOn  = () => { this.setState({loading: true }); }
    spinnerOff = () => { this.setState({loading: false}); }

    componentDidMount = async(event) => {
        try { ReactGA.pageview('/');} catch(err) {console.log('error sending GA event');}
    }
        
    // Handle user search / submit
    handleUserSearchCalc = async(event) => {
        //  Override default form submit behavior (form submit => page refresh);
        event.preventDefault();

        //  Invoke user search/retrieval via API
        this.spinnerOn();
        this.setState({hasError: false}); // Ensure clean slate on error
        const userScreenName = event.target.elements.screen_name.value;
        const resp = await axios.get(`${API_URL}/api/user/`, {params: {screen_name: userScreenName}});
        try { ReactGA.pageview(`/user?screen_name=${userScreenName}`);} catch(err) {console.log('error sending GA event');}

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
        this.spinnerOff();
    };

    //  Sync user input to state
    handleInputChange = (event) => {
        this.setState({inputScreenName: event.target.value});
    };

    render() {

        // --- Redirection: User Details Page ---
        // If valid user found, redirect to details page
        if (this.state.validUserFound) {
            return(
                <Redirect push to={{pathname: '/details'}}/>
            );
        }

        return(
            <Container fluid>
                <Row>
                    <Col>   
                        <div className="center">
                            <br/><br/><br/><br/><br/>
                            <br/><br/><br/><br/><br/>
                            <br/><br/><br/><br/><br/>

                            <h1>Tweemio</h1><br/>

                            <Form inline onSubmit={this.handleUserSearchCalc} method="get">
                                <FormControl type="text" placeholder="Twitter Username" className="mr-md-2" name="screen_name" 
                                            onChange={this.handleInputChange}/>
                                <Button variant="outline-primary" type="submit">Find</Button>
                            </Form>
                            <font color='red'>{this.state.hasError ? `User ${this.state.inputScreenName} not found, or invalid Twitter user` : ''}</font>
                            { this.state.loading ? <Spinner animation="border" role="status"/> : null }
                       </div>
                    </Col>
            </Row>
        </Container>

        );
    }

}

export { SplashMain };