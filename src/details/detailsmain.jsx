import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import { API_URL } from '../App';

import { GroupDetails } from './groupdetails';
import { Button, Spinner, Form, OverlayTrigger, 
    Tooltip, Container, Row, Col, Navbar, 
    FormControl, Jumbotron, Popover, Tabs, Tab, Accordion, Card } from 'react-bootstrap';


class DetailsMain extends React.Component {

    //  -- Event Handlers from parent / App --
    //      this.props.handleClearUser
    //      this.props.activeUserDetails
    //      this.props.activeScreenName
    //      this.props.userScreenName  (this is current user, not a func)

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
        const resp = await axios.get(`${API_URL}/api/screenmeta/`);
        this.setState({screenmeta: resp.data});
    }

    //  Get group meta info, init to state
    initGroupMeta = async(event) => {
        if (this.state.groupmeta != null)
            return;        
        const resp = await axios.get(`${API_URL}/api/groupmeta/`);
        this.setState({groupmeta: resp.data});
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
        this.setState({
                calculations: currCalculations
            });

         return resp.data;
    }

    //  Handle similarity calc when tab / accordion clicked
    handleSimilarityGroupCalcTabClick = async(groupName) => {
        if (!(groupName in this.state.calculations)) {
            console.log(`Running similarity calc for user: ${this.props.userScreenName}, group: ${groupName}`)
            this.calculateSimilarity(this.props.userScreenName, groupName)
        }
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

        //  Tabs for each similarity group
        let groupTabs = [];
        if (this.state.groupmeta != null) {
            groupTabs = Object.entries(this.state.groupmeta).map(([groupName, objval]) => {
                                return(
                                    <Card>
                                        <Accordion.Toggle as={Card.Header} eventKey={groupName}>
                                            { objval.name }
                                        </Accordion.Toggle>
                                        <Accordion.Collapse eventKey={groupName}>
                                            <Card.Body>
                                                <GroupDetails
                                                    groupCalculation={this.state.calculations[groupName] || {}}
                                                    groupMeta={this.state.groupmeta[groupName] || {}}
                                                    screenMeta={this.state.screenmeta} 
                                                    groupName={groupName} />
                                            </Card.Body>
                                        </Accordion.Collapse>
                                    </Card>
                                );
                            });
        };

        return (
            <div>
                <div> 
                    User profile section
                </div>
                <div>
                    <Accordion onSelect={this.handleSimilarityGroupCalcTabClick}>
                        { groupTabs }
                    </Accordion>
                </div>
            </div>
        );
    }

}

export { DetailsMain };