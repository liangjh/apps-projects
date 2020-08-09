import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import { API_URL } from '../App';
import { GroupDetails } from './groupdetails';
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import { Button, Image, Card, Nav, Table, Container, Row, Col, Badge } from 'react-bootstrap';


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

        //  Default selection
        //  If no group selected, select first available
        if (this.state.selectedGroupName == null) {
            const firstGroup = Object.keys(this.state.groupMeta)[0];
            this.handleSimilarityGroupCalcTabClick(firstGroup);
        }

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
        if (!(groupName in this.state.calculations))
            this.calculateSimilarity(this.props.userScreenName, groupName);
        this.setState({selectedGroupName: groupName});
    }    

    //  For readability scores
    roundNumExpr = (rawNum) => {
        const scaled = Math.round(rawNum * 10) / 10;  // 1 dec point
        return scaled;
    }
    
    render() {

        //  If screen name lost (or reset, etc); redirect back to main splash page
        if (this.props.userScreenName == null) {
            return(
                <Redirect push to={{pathname: '/'}}/>
            );
        }

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
                );
            });
        }

        return (
            <Container fluid>
                <Row><Col>
                    <Card bg="light">
                        <Card.Body>
                            <Card.Title>
                                <Table borderless size="sm">
                                    <colgroup><col style={{width: 50}}></col><col></col></colgroup>
                                    <tr>
                                        <td><Image src={this.props.userDetails.user.profile_img} rounded/></td>
                                        <td valign="middle">{this.props.userDetails.user.name}<br/>@{this.props.userScreenName}</td>
                                    </tr>
                                </Table>
                            </Card.Title>
                            <Card.Subtitle>
                                {this.props.userDetails.user.description}
                            </Card.Subtitle>
                            <Card.Text>
                                <br/>
                                <b>My Readability Scores</b><br/>
                                Your tweets are written roughly at the <u>grade <b> { Math.round(this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_grade_level)) } </b> level</u><br/>
                                <small><i>(using the Flesch Kincaid Grade Level Score;  other metrics available below)</i></small>
                                <br/><br/>

                                <Badge variant="info">Automated Readability: { this.roundNumExpr(this.props.userDetails.readability.automated_readability_index) }</Badge><br/>
                                <Badge variant="info">Coleman-Liau: { this.roundNumExpr(this.props.userDetails.readability.coleman_liau_index) }</Badge><br/>
                                <Badge variant="info">Dale-Chall:  { this.roundNumExpr(this.props.userDetails.readability.dale_chall) }</Badge><br/>
                                <Badge variant="info">Flesch-Kincaid Grade Level: { this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_grade_level) }</Badge><br/>

                            </Card.Text>
                        </Card.Body>
                    </Card>
                </Col></Row>
                <Row><Col>
                    <Nav variant="pills" onSelect={this.handleSimilarityGroupCalcTabClick} activeKey={this.state.selectedGroupName}>
                        { groupNavs }                        
                    </Nav>
                </Col></Row>
                <Row><Col>
                    <GroupDetails
                            groupCalculation={this.state.calculations[this.state.selectedGroupName] || {}}
                            groupMeta={this.state.groupMeta[this.state.selectedGroupName] || {}}
                            screenMeta={this.state.screenMeta} 
                            groupName={this.state.selectedGroupName} />
                </Col></Row>
            </Container>
        );
    }

}

export { DetailsMain };