import React from 'react';
import './App.css';
import { Button, Spinner, Form, OverlayTrigger, 
         Tooltip, Container, Row, Col, Navbar, 
         FormControl, Jumbotron } from 'react-bootstrap';
import Masonry from 'react-masonry-component';
import axios from 'axios';
import ModalWindow from './ModalWindow.js';

// Passed in by server process
// These are settings, but constant for the duration of the application
let PERSONA = process.env.REACT_APP_PERSONA
PERSONA = (PERSONA == null ? 'Trump' : PERSONA)
let API_URL = process.env.REACT_APP_API_URL;
API_URL = (API_URL == null ? 'http://localhost:8080' : API_URL)


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

  constructor(props){
    super(props);
    this.state = {
      modalShow: false
    }
  }

  showModal = () => { this.setState(prevState => ({modalShow: true  })); }
  hideModal = () => { this.setState(prevState => ({modalShow: false })); }

  render() {
    // const util = require('util');
    // console.log('current spire: '+ util.inspect(this.props));
    return(
      <div key={this.props.guid} className="tile">
          <OverlayTrigger key='right' placement='right' overlay={
            <Tooltip id={`tooltip-${this.props.guid}`}>{this.props.text}</Tooltip>
          }>
            <a href="#" onClick={this.showModal}>
              <img src={this.props.img_file} className="imgstyle" alt={this.props.text}/>
            </a>
          </OverlayTrigger>
          <ModalWindow currentspire={this.props} show={this.state.modalShow} onHide={this.hideModal} />
      </div>
    );
  }gcs
}

// Handles generating a new spire
class GenerateForm extends React.Component {
  handleSubmit = async (event) => {
    event.preventDefault();
    const resp = await axios.get(`${API_URL}/api/generate`, {params: {persona: PERSONA}});
    this.props.onSubmit(resp.data);
  }

  render() {
    return(
      <Form inline onSubmit={this.handleSubmit} method="get">
        <Button variant='primary' size="lg" type='submit' onClick={this.props.onClick}>Robot, Generate New Trumpspire!</Button>
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
    const resp = await axios.get(`${API_URL}/api/search`, {params: {q: searchq, persona: PERSONA}})
    this.props.onSubmit(resp.data)
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
        <Button variant="outline-primary" type="submit" onClick={this.props.onClick}>Search Trumpspires</Button>&nbsp;
        {this.props.hasSearchResults ? <Button variant='outline-primary' onClick={this.handleClear}>Clear Search</Button>: null}
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
    const resp = await axios.get(`${API_URL}/api/recents`, {params: {persona: PERSONA}});
    this.handleRecents(resp.data);
  }

  //  Get latest spires upon app (component) load
  componentDidMount() { this.loadRecents(); }

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
            <h4>Inspirational sayings from the <a href="https://en.wikipedia.org/wiki/Donald_Trump">45th President of the United States</a></h4>
            <p>We've taken a bunch of the President's tweets and speeches and built a Markov matrix.  <br/>Each Trumpspire is an original work that will leave you inspired -  <b>*Trumpspired*</b>.</p>
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
        </Container>
      </div>
    );
  }
}

export default App;

