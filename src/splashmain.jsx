import React from 'react';
import logo from './logo.svg';
import './App.css';
import { API_URL, GA_KEY } from './App'
import { BrowserRouter as Router, Redirect } from 'react-router-dom';
import axios from 'axios';
import ReactGA from 'react-ga';
import { Button, Spinner, Form, Container, Row, Col, FormControl } from 'react-bootstrap';
import { UserReel } from './details/userreel';
import queryString from 'query-string';


class SplashMain extends React.Component {

    //  -- Event handlers, from App (parent container) --
    //      this.props.handleUseDetails
    //      this.props.handleClearUser
    //      this.props.screenMeta

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
        //  Initialize google analytics
        console.log(`GA Key is initialized to: ${GA_KEY}`);
        ReactGA.initialize(GA_KEY);       
        try { ReactGA.pageview('/');} catch(err) {console.log('error sending GA event');}
        try { this.handleUserInitLoad(); } catch(err) {console.log('error on init-load user')}  // do nothing if something goes wrong
    }

    // Handle user load (userid passed to page)
    handleUserInitLoad = () => {
        const kvs = queryString.parse(window.location.search);
        if ('screen_name' in kvs) 
            this.handleUserSearch(kvs.screen_name);
    };

    // Handle user search / submit
    handleUserSearchForm = async(event) => {
        //  Override default form submit behavior (form submit => page refresh);
        event.preventDefault();
        this.handleUserSearch(event.target.elements.screen_name.value);
    };

    handleUserSearch = async(userScreenName) => {
        //  Invoke user search/retrieval via API
        this.spinnerOn();
        this.setState({hasError: false}); // Ensure clean slate on error
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
    handleSetScreenName = (screenName) => {
        this.setState({inputScreenName: screenName});
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
                <Row><Col><br/><br/><br/><br/><br/></Col></Row>
                <Row>
                    <Col className="d-flex justify-content-center align-items-center">   
                        <h1>Tweemio</h1>
                    </Col>
                </Row>
                <Row><Col><br/></Col></Row>
                <Row>
                    <Col className="d-flex justify-content-center align-items-center">   
                            <Form inline onSubmit={this.handleUserSearchCalc} method="get">
                                <FormControl type="text" placeholder="Twitter Username" className="mr-md-2" name="screen_name" 
                                            onChange={(event) => { this.handleSetScreenName(event.target.value) }}/>
                                <Button variant="outline-primary" type="submit">Find</Button>
                            </Form>
                            <font color='red'>{this.state.hasError ? `User ${this.state.inputScreenName} not found, or invalid Twitter user` : ''}</font>
                            { this.state.loading ? <Spinner animation="border" role="status"/> : null }
                    </Col>
                </Row>
                <Row><Col><br/></Col></Row>
                <Row>
                    <Col className="d-flex justify-content-center align-items-center">
                        <UserReel screenMeta={this.props.screenMeta} handleUserSearch={this.handleUserSearch}/>
                    </Col>
                </Row>
            </Container>
        );
    }

}

export { SplashMain };