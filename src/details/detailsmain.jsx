import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';

import { Button, Spinner, Form, OverlayTrigger, 
    Tooltip, Container, Row, Col, Navbar, 
    FormControl, Jumbotron, Popover, Tabs, Tab, Sonnet } from 'react-bootstrap';



class DetailsMain extends React.Component {

    //  -- Event Handlers from parent / App --
    //      this.props.handleClearUser
    //      this.props.activeUserDetails
    //      this.props.activeScreenName

    state = {
        //  Meta-information, settings 
        screenmeta: null,
        groupmeta: null,
        calculations: {}
    }

    constructor(props) {
        super(props);

        //  Get screen meta info (only necessary to do once)
        this.initScreenMeta();
        this.initGroupMeta();
    }

    // componentDidMount = async(event) => {}

    //  Get screen meta info, init to state
    initScreenMeta = async(event) => {
        if (this.state.screenmeta != null)
            return;
        const resp = await axios.get(`http://localhost:5000/api/screenmeta/`);
        console.log(resp.data);
        this.setState({screenmeta: resp.data});
    }

    //  Get group meta info, init to state
    initGroupMeta = async(event) => {
        if (this.state.groupmeta != null)
            return;        
        const resp = await axios.get('http://localhost:5000/api/groupmeta/');
        console.log(resp.data);
        this.setState({groupmeta: resp.data});
    }

    //  Getters to pass into group details tab
    getScreenMeta = () => { return this.state.screenmeta; }
    getGroupMeta = (groupName) => { return this.state.groupmeta[groupName]; }
    getGroupCalculation = (groupName) => { return this.state.calculations[groupName]; }

    //  Main similarity calculation: for current screen name, for selected group
    handleUserCalculate = (userScreenName, groupName) => {
        if (groupName in this.state.calculations) 
            return;
        const resp = axios.get(`http://localhost:5000/api/calculate/`, {params: {screen_name: userScreenName, group: groupName}});
        this.setState({
                calculations: { 
                    groupName: resp.data
                }
            });
        return resp.data;
    }

    render() {
        /*
            Rendering components (notes)
            - user section (profile, details)
            - readability scores
            - tabs, for each "group"
            - for each tab, pass down: 
                (a) group meta for group, 
                (b) screen meta (full dictionary)
                (c) calculation results for group
        */

        console.log('---- in detailsmain.render() ----')
        console.log(this.state.groupmeta);

        if (this.state.groupmeta != null)
        {
            Object.entries(this.state.groupmeta).forEach(group => console.log(`detailsmain.render: ${group}`));
        };


        return (
            <div>
                <div> User profile section</div>
                <div>
                    <Tabs>
                        <Tab eventKey="a" title="TestA">
                            This is a test of a tab: A
                        </Tab>
                        <Tab eventKey="b" title="TestB">
                            This is a test of a tab: B
                        </Tab>
                    </Tabs>
                </div>
            </div>
        );
    }

}

export { DetailsMain };