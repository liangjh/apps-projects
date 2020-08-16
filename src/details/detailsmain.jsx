import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';
import { API_URL } from '../App';
import { GroupDetails } from './groupdetails';
import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import { Button, Spinner, Image, Card, Nav, Table, Container, Row, Col, Badge, Navbar, Modal } from 'react-bootstrap';
import ReactGA from 'react-ga';


// Initialize GA component
ReactGA.initialize(GA_KEY);

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
        showReadabilityModal: false,
        showMatchModal: false
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
    handleShowMatch = () => { this.setState({showMatchModal: true}); }
    handleHideMatch = () => { this.setState({showMatchModal: false}); }
    handleShowReadability = () => { this.setState({showReadabilityModal: true}); }
    handleHideReadability = () => { this.setState({showReadabilityModal: false}); }

    //  Handle similarity calc when tab / accordion clicked
    //  Do not recalc if we already have results for this group
    handleSimilarityGroupCalcTabClick = async(groupName) => {
        this.spinnerOn();
        if (!(groupName in this.state.calculations))
            this.calculateSimilarity(this.props.userScreenName, groupName);
        this.setState({selectedGroupName: groupName});
        this.spinnerOff();

        // log usage (user, screen name)
        try { ReactGA.pageview(`/details?screen_name=${this.props.userScreenName}&group=${groupName}`);} catch(err) {console.log('error sending GA event');}
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
                                        <td><a href={`http://www.twitter.com/${this.props.userScreenName}`} target="_blank"><Image src={this.props.userDetails.user.profile_img} rounded/></a></td>
                                        <td><a href={`http://www.twitter.com/${this.props.userScreenName}`} target="_blank" style={{color:'inherit', textDecoration:'none'}}>
                                                     {this.props.userDetails.user.name}<br/>@{this.props.userScreenName}</a></td>
                                    </tr>
                                </Table>
                            </Card.Title>
                            <Card.Subtitle className="mb-2 text-muted">
                                <div style={{width:"475px"}}>{this.props.userDetails.user.desc}</div>
                            </Card.Subtitle>
                            <Card.Text>    
                                Your tweets are written roughly at the &nbsp;
                                    <Badge variant="success" style={{fontSize: "0.9rem"}}>Grade <b> { Math.round(this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_grade_level)) } </b> Level</Badge><br/>
                                    &nbsp;&nbsp;&nbsp;<small><i>(using the Flesch Kincaid Grade Level Score)</i></small>
                                <br/><br/>

                                <Badge variant="secondary" style={{fontSize: "0.9rem"}}>Automated Readability: { this.roundNumExpr(this.props.userDetails.readability.automated_readability_index) }</Badge><br/>
                                <Badge variant="secondary" style={{fontSize: "0.9rem"}}>Coleman-Liau: { this.roundNumExpr(this.props.userDetails.readability.coleman_liau_index) }</Badge><br/>
                                <Badge variant="secondary" style={{fontSize: "0.9rem"}}>Dale-Chall:  { this.roundNumExpr(this.props.userDetails.readability.dale_chall) }</Badge><br/>
                                <Badge variant="secondary" style={{fontSize: "0.9rem"}}>Flesch-Kincaid Grade Level: { this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_grade_level) }</Badge><br/>
                                <Badge variant="secondary" style={{fontSize: "0.9rem"}}>Flesch-Kincaid Reading Ease: { this.roundNumExpr(this.props.userDetails.readability.flesch_kincaid_reading_ease) }</Badge><br/><br/>

                                <Button variant="outline-primary" onClick={this.handleShowReadability}><small>About Readability Scores</small></Button>&nbsp;&nbsp;
                                <Modal show={this.state.showReadabilityModal} onHide={this.handleHideReadability}>
                                    <Modal.Header closeButton>About Readability Scores</Modal.Header>
                                    <Modal.Body>
                                        A good introduction to readability metrics can be found here:  <a href="https://en.wikipedia.org/wiki/Readability" target="_blank">Wikipedia on Readability</a>.<br/><br/>
                                        <b>Flesch-Kincaid</b>:<br/>
                                        Utilizes average sentence length and average word length in syllables to compose an overall score on reading ease.  
                                        This formula is extended to a grade-level equivalent<br/><br/>
                                        <b>Dale-Chall</b>:<br/>
                                        Given a collections of words at the 4th grade-level, compose an overall score based on percentage of words found
                                        in the 4th grade list and average sentence length.  The score roughly maps to the following grade levels: <br/>
                                        (0-4.9: grade 4, 5-5.9: grades 5-6, 6-6.9: grades 7-8, 7-7.9: grades 9-10; 8-8.9: grades 11-12, 9-9.9: undergraduate, 10+: graduate)<br/><br/>
                                        <b>Coleman-Liau</b>:<br/>
                                        Constructs a readability score based on average number of letters in words and average number of sentences in 100-word blocks.<br/>
                                    </Modal.Body>
                                </Modal>
                                <Button variant="outline-primary" onClick={this.handleShowMatch}><small>About Tweemio Match</small></Button>
                                <Modal show={this.state.showMatchModal} onHide={this.handleHideMatch}>
                                    <Modal.Header closeButton>About Tweemio Match</Modal.Header>
                                    <Modal.Body>
                                        Tweemio analyzes your tweets and compiles a similarity match against prolific personalities in the Twitterverse.  
                                        The similarity algorithm analyzes style, word frequency and context to compile an average match score.  
                                        Alongside each personality are the top tweets from *your feed* that the algorithm has determined to be a match.
                                        <br/><br/>
                                        We're always looking for feedback, so if there is a personality you'd like to see featured or recommendations on how to improve, 
                                        tweet us over at <a href="http://www.twitter.com/tweemio" target="_blank">@Tweemio</a>
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
                            groupName={this.state.selectedGroupName} 
                            userScreenName={this.props.userScreenName}/>
                </Col></Row>
            </Container>
        );
    }

}

export { DetailsMain };