import React from 'react';
import { Button, Spinner, Form, Tooltip, Container, Row, Col, Navbar, CardColumns, Card, Image  } from 'react-bootstrap';

class GroupDetails extends React.Component {

    //  -- Upstream data, from parent (details main) --
    //      this.props.screenMeta
    //      this.props.groupMeta
    //      this.props.groupCalculation
    //      this.props.groupName   (note: this is a property, not an event handler)

    state = {
        selectedUser: null
    }

    constructor(props) {
        super(props);
    }
    
    handleSelectSimilarityDetails = (selectedUser) => {
        this.setState({ selectedUser: selectedUser })
    }

    //  Given a number, rounds to whole pct, and handles special cases (i.e. "< 1%"):  note, returns string!
    roundPctExpr = (rawPct) => {
        const wholePct = Math.round(rawPct * 100);
        if (wholePct < 1)
            return("< 1%");
        return(`${wholePct} %`);
    }

    render() {
        /*
            Rendering Components
            - left panel: all characters and profile details
                - profile pic, user details
                - overall similarity score
            - right panel: 
                - selected user - list of top-scoring similar tweets from main user
        */

        //  No group selected or empty group calc details?  Return blank
        if (this.props.groupName == null || 
            this.props.groupCalculation == null || Object.entries(this.props.groupCalculation) < 1 ) { 
            return(
                <Container fluid>
                    <Row><Col></Col></Row>
                </Container>
            );
        }
        
        //  Construct response, in card column layout
        const cardEntries = Object.entries(this.props.groupCalculation.similarity).map(
                                    ([screenName, similarityDetails]) => {                  
                                        const metaDetails = this.props.screenMeta[screenName];  // details for each SN in group
                                        const scoreRounded = null;
                                        return(
                                            <Card> 
                                                <Card.Body>
                                                    <Card.Title>
                                                        <Image src={metaDetails.profile_img} rounded/>
                                                        &nbsp;&nbsp;{metaDetails.name}
                                                    </Card.Title>
                                                    <Card.Subtitle className="mb-2 text-muted">
                                                        <b>@{screenName}</b><br/>
                                                        { metaDetails.description }
                                                    </Card.Subtitle>
                                                    <Card.Text>
                                                        <h2>{this.roundPctExpr(similarityDetails.avg_similarity_score)}</h2>
                                                    </Card.Text>
                                                </Card.Body>
                                            </Card>
                                        );
                                    });

        return( 
        <div>
            <div> 
                { this.props.groupMeta.name }<br/><br/>

                <Container fluid>
                    <Row>
                        <Col>
                            <CardColumns>
                                { cardEntries }
                            </CardColumns>
                        </Col>
                    </Row>
                </Container>


            </div>
        </div>
        );
    }


}

export { GroupDetails };

