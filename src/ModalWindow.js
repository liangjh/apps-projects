import React from 'react';
import { Modal, Container, Row, Col } from 'react-bootstrap'
import './App.css';
import {FacebookShareButton, TwitterShareButton, PinterestShareButton, 
        FacebookIcon, TwitterIcon, PinterestIcon} from 'react-share'

// Constants / passed from system
let ACCT_NAME = process.env.REACT_APP_ACCT_NAME; ACCT_NAME = (ACCT_NAME == null ? "@TrumpSpired" : ACCT_NAME);


class ModalWindow extends React.Component {

  render() {

    // const util = require('util');    
    // console.log('props: ' + util.inspect(this.props));
    if (this.props.currentspire === null || this.props.currentspire === undefined) 
      return null;    

    let msgtext = `${this.props.currentspire.text} ${ACCT_NAME}`;

    return (
      <Modal show={this.props.show} onHide={this.props.onHide}>
        <Modal.Header closeButton="true">
          <Modal.Title>View / Publish Trumpspire</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Container>
            <Row>
              <Col>
                <img src={this.props.currentspire.img_file} className="imgstyledetailed"/><br/>
              </Col>
            </Row>
            <Row>
              <Col><br/>
                  <div className="shareNetwork">
                    <FacebookShareButton url={this.props.currentspire.img_file} quote={msgtext} >
                      <FacebookIcon size={45} round/>
                    </FacebookShareButton>
                  </div>
                  <div className="shareNetwork">
                    <TwitterShareButton url={this.props.currentspire.img_file} title={msgtext} >
                      <TwitterIcon size={45} round/>
                    </TwitterShareButton>
                  </div>
                  <div className="shareNetwork">
                    <PinterestShareButton url={this.props.currentspire.img_file} media={this.props.currentspire.img_file} description={msgtext} >
                      <PinterestIcon size={45} round/>
                    </PinterestShareButton>
                  </div>
                  <div className="shareNetwork">
                  <i>(click on icons to share)</i>
                  </div>
              </Col>
            </Row>
          </Container>
        </Modal.Body>
      </Modal>
    );
  }
}

export default ModalWindow;
