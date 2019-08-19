import React from 'react';
import './App.css';
import { Button, Container, Row, Col } from 'react-bootstrap';
import Masonry from 'react-masonry-component';
import axios from 'axios';

let API_URL = process.env.REACT_APP_API_URL;
if (API_URL == null) 
  API_URL = 'http://localhost:8080'

// Render generated spires
class SpiresGenerated extends React.Component {
  render(){
    return(
      <Masonry>
        {this.props.spires.map(spire => <Spire {...spire}/>)}
      </Masonry>
    );
  }
}

class Spire extends React.Component {
  render() {
    const spire = this.props;
    return(
      <div>
          <figure style={{"display":"table"}}>
            <img src={spire.image.small}/>
            <figcaption style={{"display":"table-caption","caption-side":"bottom"}}>
                <small>{spire.text}</small>
            </figcaption>
          </figure>
      </div>
    );
  }
}

class Form extends React.Component {
  // Generate button
  handleSubmit = async (event) => {
    event.preventDefault();
    const generateEndpoint = API_URL + '/api/generate';
    const resp = await axios.get(generateEndpoint);
    this.props.onSubmit(resp.data);
  }

  render() {
    return(
      <form onSubmit={this.handleSubmit}>
        <button>
          <Button variant='primary' size='lg'>Generate</Button>       
        </button>
      </form>
    );
  }
}


class App extends React.Component {

  state = {
    spires: [],  // list of inspirations generated by user
    recentspires: []
  };

  // New generated spire
  addNewSpire = (spireData) => {
    this.setState(prevState => ({
      spires: [...prevState.spires, spireData],
    }));
  };

  //  Recent spires
  handleRecents = (recentData) => {
    this.setState(prevState => ({
      recentspires: recentData
    }));
  };

  loadRecents = async(event) => {
    const recentEndpoint = API_URL + '/api/recents';
    const resp = await axios.get(recentEndpoint);
    this.handleRecents(resp.data);
  };

  // Initialize latest spires 
  componentDidMount() {
    this.loadRecents();
  }

  // Render full application 
  render() {
    return (
      <Container>
        <Row>
          <Col md={true} lg={true} xl={true}>
            <h1>Trumpspired</h1>
          </Col>
        </Row>
        <Row>
          <Col md={true} lg={true} xl={true}>
            <Form onSubmit={this.addNewSpire} />
          </Col>
        </Row>
        <Row>
          <Col md={true} lg={true} xl={true}>
            <SpiresGenerated spires={this.state.spires} />
          </Col>
        </Row>
        <Row>
          <Col md={true} lg={true} xl={true}>
            <SpiresGenerated spires={this.state.recentspires} />
          </Col>
        </Row>
      </Container>
    );
  }
}

export default App;
