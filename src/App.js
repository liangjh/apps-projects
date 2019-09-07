import React from 'react';
import './App.css';
import { Button, Spinner, Form, OverlayTrigger, 
         Tooltip, Container, Row, Col, Navbar, 
         FormControl, Jumbotron, Popover } from 'react-bootstrap';
import Masonry from 'react-masonry-component';
import axios from 'axios';
// import ModalWindow from './ModalWindow.js';
import ReactGA from 'react-ga'
import {FacebookShareButton, TwitterShareButton, PinterestShareButton, 
        FacebookIcon, TwitterIcon, PinterestIcon} from 'react-share'


// Passed in by starting server; treat as constants within application
let PERSONA   = process.env.REACT_APP_PERSONA; PERSONA = (PERSONA == null ? 'Trump' : PERSONA)
let API_URL   = process.env.REACT_APP_API_URL; API_URL = (API_URL == null ? 'http://localhost:8080' : API_URL)
let MAX_GEN   = process.env.REACT_APP_MAX_GEN; MAX_GEN = (MAX_GEN == null ? 5 : MAX_GEN);
let GA_KEY    = process.env.REACT_APP_GA_KEY;  GA_KEY  = (GA_KEY  == null ? 'UA-147177121-1' : GA_KEY);
let ACCT_NAME = process.env.REACT_APP_ACCT_NAME; ACCT_NAME = (ACCT_NAME == null ? "@TrumpSpired" : ACCT_NAME);


// Initialize hook to google analytics 
ReactGA.initialize(GA_KEY);

// Render generated spires
class SpiresGenerated extends React.Component {
  render(){
    return(
      <Masonry className="masonry-container">
        {this.props.spires.map(spire => <Spire {...spire} />)}
      </Masonry>
    );
  }
}

class Spire extends React.Component {
  
  render() {
    // const util = require('util');
    // console.log('current spire: '+ util.inspect(this.props));
    let msgtext = `${this.props.text} ${ACCT_NAME}`;
    return(
      <div key={this.props.guid} className="tilecontainer">
          <img src={this.props.img_file} className="imgstyle tileimage" alt={this.props.text}/>
 
          <div className="topright">
            <div className="shareNetwork">
              <FacebookShareButton url={this.props.img_file} quote={msgtext} >
                <FacebookIcon size={25} round/>
              </FacebookShareButton>
            </div>
            <div className="shareNetwork">
              <TwitterShareButton url={this.props.img_file} title={msgtext} >
                <TwitterIcon size={25} round/>
              </TwitterShareButton>
            </div>
            <div className="shareNetwork">
              <PinterestShareButton url={this.props.img_file} media={this.props.img_file} description={msgtext} >
                <PinterestIcon size={25} round/>
              </PinterestShareButton>
            </div>
          </div>
      </div>
    );
  }
}


// Handles generating a new spire
class GenerateForm extends React.Component {

  state = {
    gencount: 0
  }

  handleSubmit = async (event) => {
    event.preventDefault();
    this.incremGenCount();
    try { ReactGA.pageview(`/app/generate?persona=${PERSONA}`); } catch(err) {console.log('error sending GA event');}
    const resp = await axios.get(`${API_URL}/api/generate`, {params: {persona: PERSONA}});
    this.props.onSubmit(resp.data);
  }

  incremGenCount = () => {
    this.setState(prevState => ({gencount: this.state.gencount + 1}));
  }

  render() {
    return(
      <Form inline onSubmit={this.handleSubmit} method="get">
        <Button variant='primary' size="lg" type='submit' 
              onClick={this.props.onClick} 
              disabled={this.state.gencount > MAX_GEN}>
              Generate New Trumpspire!
        </Button>&nbsp;&nbsp;
        {(this.state.gencount > MAX_GEN) ? <i><small><font color="red">Maximum of {MAX_GEN} allowed.</font></small></i> : null }
      </Form>
    );
  }
}

// Handles search of existing spires (i.e. within spire database)
class SearchForm extends React.Component {

  state = {
    q: ''
  };

  handleSubmit = async (event) => {
    event.preventDefault();
    // const util = require('util');
    // console.log('current spire: '+ util.inspect(event.target.elements.q.value));
    const searchq = event.target.elements.q.value;
    try { ReactGA.pageview(`/app/search?q=${searchq}`); } catch(err) {console.log('error sending GA event');}
    const resp = await axios.get(`${API_URL}/api/search`, {params: {q: searchq, persona: PERSONA}})
    this.props.onSubmit(searchq, resp.data);
  }  

  handleClear = (event) => {
    this.setState(prevState => ({q: ''}));
    this.props.onClear();
  }

  handleInputChange = (event) => {
    this.setState ({ q: event.target.value});
  }

  render() {
    return(
      <Form inline onSubmit={this.handleSubmit} method="get">
        <FormControl type="text" placeholder="Search all Trumpspires" className="mr-sm-2" id="q" name="q" value={this.state.q} onChange={this.handleInputChange}/>
        <Button variant="outline-primary" type="submit" onClick={this.props.onClick}>Search</Button>&nbsp;
        {!(this.state.q == null || this.state.q == '') ? <Button variant='outline-primary' onClick={this.handleClear}>Clear Search</Button>: null}
      </Form>
    );
  }
}

class App extends React.Component {

  state = {
    genspires: [],    // list of inspirations generated by user
    recentspires: [], // list of last "x" spires in system 
    searchspires: [], // list of search results 
    loading: false,   // controls spinner state
  };

  // Spinner for all submissions
  spinnerOn  = () => { this.setState(prevState => ({loading: true })); }
  spinnerOff = () => { this.setState(prevState => ({loading: false})); }

  // New generated spire
  addNewSpire = (spireData) => {
    this.setState(prevState => ({
      genspires: [spireData, ...prevState.genspires],
    }));
    this.spinnerOff();
  };

  // Search results handler
  handleSearchResults = (searchData) => { 
    this.setState(prevState => ({searchspires: searchData})); 
    this.spinnerOff();
  }
  
  clearSearchResults = () => {
    this.setState(prevState => ({searchspires: []}));
  }

  // Recent spires
  handleRecents = (recentData) => { 
    this.setState(prevState => ({recentspires: recentData})); 
  }

  loadRecents = async(event) => {
    try { ReactGA.pageview('/app/recents'); } catch(err) {console.log('error sending GA event');}
    const resp = await axios.get(`${API_URL}/api/recents`, {params: {persona: PERSONA}});
    this.handleRecents(resp.data);
  }

  //  Get latest spires upon app (component) load
  componentDidMount() { 
    try { ReactGA.pageview('/app'); } catch(err) {console.log('error sending GA event');}
    this.loadRecents(); 
  }

  render() {

    let generatedandrecent = this.state.genspires.concat(this.state.recentspires);
    return (
      <div>
        <Navbar bg="light" variant="light" fluid="true">
          <Navbar.Brand href="#">
            <img src="trumpspired-logo_64x100.png" height="50" width="32"/>&nbsp;&nbsp;
          </Navbar.Brand>
          <SearchForm onSubmit={this.handleSearchResults} onClick={this.spinnerOn} onClear={this.clearSearchResults} hasSearchResults={(this.state.searchspires.length > 0)}/>&nbsp;&nbsp;
          { this.state.loading ? <Spinner animation='border' role='status'/> : null }              
        </Navbar>

        <Jumbotron fluid="true" className="jumbotron">
          <Container fluid className="noPadding">
          <Row className="noMargin">
            <Col sm={2}>
              <img src="trumpspired-logo_160x250.png"/>
            </Col>
            <Col lg>
            <h1>Trumpspired</h1><br/>
            <h4>Sayings inspired by the <a href="https://en.wikipedia.org/wiki/Donald_Trump">45th President of the United States</a></h4>
            <p>We've taken a bunch of 45's tweets and speeches and built a Markov matrix.  <br/>Each Trumpspire is an original work that will leave you inspired.  <b>*Trumpspired*</b>.</p>
            <GenerateForm onSubmit={this.addNewSpire} onClick={this.spinnerOn}/>                      
            </Col>
          </Row>
          </Container>
        </Jumbotron>

        <Container fluid className="noPadding">
          <Row className="noMargin">
            <Col className="noPadding">{ (this.state.searchspires.length > 0) ? <SpiresGenerated spires={this.state.searchspires} /> : null }</Col>
          </Row>
          <Row className="noMargin">
            <Col className="noPadding">{ (this.state.searchspires.length > 0) ? null : <SpiresGenerated spires={generatedandrecent} /> }</Col>          
          </Row>
          <Row className="noMargin">
            <Col>
              <hr width='100%'/>
              <OverlayTrigger trigger ="hover" placement="top" overlay={
                <Popover id="popover-about">
                  <Popover.Title as="h3">About Trumpspired</Popover.Title>
                  <Popover.Content>
                    <p>Trumpspired was created in jest and good fun, as a bot that can emulate the style of our 45th President.  45 is the most prolific tweeter to occupy high office, and his spontaneous, incoherent speaking style lends well to automated processes (more on this in the Markov Model link).</p>  <p>Each trumpspire created is new.  We immortalize these sayings with inspirational images framed in the manner of inspirational posters from the 1990's.  </p><p>Enjoy, and feel free to share on social media.</p>
                  </Popover.Content>
                </Popover>
              }>
                <a href="javascript:void(0);">About Trumpspired</a>
              </OverlayTrigger>
                &nbsp;&nbsp;|&nbsp;&nbsp;
              <OverlayTrigger trigger ="hover" placement="top" overlay={
                <Popover id="popover-markov">
                  <Popover.Title as="h3">About Markov Models</Popover.Title>
                  <Popover.Content>
                  <i>Coming soon</i>
                  </Popover.Content>
                </Popover>
              }>
                <a href="javascript:void(0);">About Markov Models</a>
              </OverlayTrigger>

                &nbsp;&nbsp;|&nbsp;&nbsp;
              <a href="http://twitter.com/trumpspired">Follow @Trumpspired</a><br/>
              <small>
              <b>A Production of Trellis Media LLC. &copy;</b><br/><br/>
              <i>** Note: the quotes generated above are based on actual speeches and tweets delivered by Donald Trump, <br/> but are <b>not actual things he has said.</b> We thought we'd add a moment (or several moments) of levity to your day. </i>
              </small>
              <hr width='100%'/>
              <br/><br/><br/><br/>
            </Col>
          </Row>
        </Container>
      </div>
    );
  }
}

export default App;

