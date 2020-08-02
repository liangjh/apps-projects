import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import { API_URL } from '../App';

import { GroupDetails } from './groupdetails';
import { Button, Spinner, Form, OverlayTrigger, 
    Tooltip, Container, Row, Col, Navbar, 
    FormControl, Jumbotron, Popover, Tabs, Tab, Accordion, Card, Nav } from 'react-bootstrap';


class DetailsMain extends React.Component {

    //  -- Event Handlers from parent / App --
    //      this.props.handleClearUser  (callback func)
    //      this.props.userDetails  (current user details)
    //      this.props.userScreenName  (this is current user, not a func)

    state = {
        //  Meta-information, settings 
        screenMeta: {},
        groupMeta: {},
        calculations: {},
        selectedGroupName: null
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
        if (Object.keys(this.state.screenMeta).length > 0)
            return;
        const resp = await axios.get(`${API_URL}/api/screenmeta/`);
        this.setState({screenMeta: resp.data});
    }

    //  Get group meta info, init to state
    initGroupMeta = async(event) => {
        if (Object.keys(this.state.groupMeta).length > 0)
            return;        
        const resp = await axios.get(`${API_URL}/api/groupmeta/`);
        this.setState({groupMeta: resp.data});
    }

    //  Similarity calculation to API: for current screen name, for selected group
    calculateSimilarity = async(userScreenName, groupName) => {
        if (groupName in this.state.calculations) 
            return;
        //  Call API to calculate similarity scores
        const resp = await axios.get(`${API_URL}/api/calculate/`, {params: {screen_name: userScreenName, group: groupName}});
        //  Add to calculations
        let currCalculations = this.state.calculations;
        currCalculations[groupName] = resp.data;
        this.setState({calculations: currCalculations});

         return resp.data;
    }

    //  Handle similarity calc when tab / accordion clicked
    //  Do not recalc if we already have results for this group
    handleSimilarityGroupCalcTabClick = async(groupName) => {
        if (!(groupName in this.state.calculations)) {
            this.calculateSimilarity(this.props.userScreenName, groupName)
        }
        this.setState({selectedGroupName: groupName});
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

        //  Navs for each similarity group
        let groupNavs = [];
        if (this.state.groupMeta != null) {
            groupNavs = Object.entries(this.state.groupMeta).map(([groupName, objval]) => {
                return(
                    <Nav.Item>
                        <Nav.Link eventKey={groupName}>
                            { objval.name }
                        </Nav.Link>
                    </Nav.Item>
                )
            });
        }

        return (
            <div>
                <div> 
                    User profile section // TBD filled in
                </div>
                <div>
                    <Nav variant="pills" onSelect={this.handleSimilarityGroupCalcTabClick}>
                        { groupNavs }
                        <GroupDetails
                                groupCalculation={this.state.calculations[this.state.selectedGroupName] || {}}
                                groupMeta={this.state.groupMeta[this.state.selectedGroupName] || {}}
                                screenMeta={this.state.screenMeta} 
                                groupName={this.state.selectedGroupName} />
                    </Nav>
                </div>
            </div>
        );
    }

}

export { DetailsMain };