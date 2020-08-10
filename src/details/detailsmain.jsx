import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import { API_URL } from '../App';
import { GroupDetails } from './groupdetails';
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import { Button, Spinner, Image, Card, Nav, Table, Container, Row, Col, Badge, Navbar, Modal } from 'react-bootstrap';


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
        selectedGroupName: null,
        loading: false,
        showReadabilityModal: false
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

    //  UI Effect Handlers
    spinnerOn  = () => { this.setState({loading: true }); }
    spinnerOff = () => { this.setState({loading: false}); }
    handleShowModal = () => { this.setState({showReadabilityModal: true}); }
    handleHideModal = () => { this.setState({showReadabilityModal: false}); }

    //  Handle similarity calc when tab / accordion clicked
    //  Do not recalc if we already have results for this group
    handleSimilarityGroupCalcTabClick = async(groupName) => {
        this.spinnerOn();
        if (!(groupName in this.state.calculations))
            this.calculateSimilarity(this.props.userScreenName, groupName);
        this.setState({selectedGroupName: groupName});
        this.spinnerOff();
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
                    <Navbar bg="light" variant="light" fluid>
                        <Navbar.Brand href="/">Tweemio</Navbar.Brand>
                    </Navbar>
                </Col></Row>
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
                                <Badge variant="info">Flesch-Kincaid Reading Ease: { this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_reading_ease) }</Badge><br/>

                                <Button variant="link" onClick={this.handleShowModal}>About Readability Scores</Button>
                                <Modal show={this.state.showReadabilityModal} onHide={this.handleHideModal}>
                                    <Modal.Header closeButton>About Readability Scores</Modal.Header>
                                    <Modal.Body>
                                        A good introduction to the field of readability can be found here:  <a href="https://en.wikipedia.org/wiki/Readability">Wikipedia on Readability</a>.<br/><br/>
                                        <b>Flesch-Kincaid</b>:<br/>
                                        Utilizes average sentence length (ASL) and average word length in syllables (ASW) to compose an overall score on reading ease.  
                                        This formula was extended to derive a grade-level equivalent<br/><br/>
                                        <b>Dale-Chall</b>:<br/>
                                        Given a series of words comprehended by 4th grade students, compose an overall score based on percentage of words found
                                        in list as well as average sentence length to derive a difficulty score.  The score roughly maps: <br/>
                                        (0-4.9: grade 4, 5-5.9: grades 5-6, 6-6.9: grades 7-8, 7-7.9: grades 9-10; 8-8.9: grades 11-12, 9-9.9: grades 11-12)<br/><br/>
                                        <b>Coleman-Liau</b>:<br/>
                                        Utilizes average number of letters in words as well as average number of sentences in 100-word blocks to construct a difficult score.<br/>
                                    </Modal.Body>
                                </Modal>
            
                            </Card.Text>
                        </Card.Body>
                    </Card>
                </Col></Row>
                <Row><Col>
                    { this.state.loading ? <Spinner animation="border" role="status"/> : null }
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