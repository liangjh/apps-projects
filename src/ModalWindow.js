import React from 'react';
import { Modal } from 'react-bootstrap'
import './App.css';
import {FacebookShareButton, TwitterShareButton, FacebookIcon, TwitterIcon} from 'react-share'


class ModalWindow extends React.Component {

  constructor(props) {
    super(props);
  }

  
  render() {

    // const util = require('util');    
    // console.log('props: ' + util.inspect(this.props));
    if (this.props.currentspire == null || this.props.currentspire == undefined) 
      return null;    

    return (
      <Modal show={this.props.show} onHide={this.props.onHide}>
        <Modal.Header closeButton="true">
          <Modal.Title>View / Publish Poster</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <img src={this.props.currentspire.img_file_sm} className="imgstyledetailed"/><br/>
          <FacebookShareButton url={this.props.currentspire.img_file_sm} 
                               quote={this.props.currentspire.text} >
            <FacebookIcon size={45} />
          </FacebookShareButton>
          <TwitterShareButton url={this.props.currentspire.img_file_sm} 
                              title={this.props.currentspire.text} >
            <TwitterIcon size={45} />
          </TwitterShareButton>
        </Modal.Body>
      </Modal>
    );
  }
}

export default ModalWindow;
