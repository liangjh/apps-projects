import React from 'react';
import { Button, Spinner, Badge, Table, Accordion, Container, Row, Col, Navbar, CardColumns, Card, Image  } from 'react-bootstrap';

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
    
    //  Given a number, rounds to whole pct, and handles special cases (i.e. "< 1%"):  note, returns string!
    roundPctExpr = (rawPct) => {
        const wholePct = Math.round(rawPct * 100);
        return wholePct;
    }

    badgeColor = (value) => {
        const clr = (value >= 70 ? 'success' : ( value > 25 ? 'warning' : ( value > 10 ? 'info' : 'secondary' ) ) )
        return clr;
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
                    <Row>
                        <Col>
                            Click on a category above to see your similarity score
                        </Col>
                    </Row>
                </Container>
            );
        }
        
        //  Construct response, in card column layout
        const cardEntries = Object.entries(this.props.groupCalculation.similarity).map(
                    ([screenName, similarityDetails]) => {                  
                        const metaDetails = this.props.screenMeta[screenName];  // details for each SN in group

                        //  Top similar, for currrent screen name
                        let topSimilar = [];
                        let similarJsx = null;
                        if (similarityDetails.top_similar.length > 0) {
                            topSimilar = similarityDetails.top_similar.map((similarityElem) => {
                                                    const score = this.roundPctExpr(similarityElem.score);
                                                    return(
                                                        <tr>
                                                            <td>
                                                                <b><Badge variant={this.badgeColor(score)}>{score}% Match</Badge></b><br/>
                                                                {similarityElem.text}
                                                            </td>
                                                        </tr>
                                                    );
                                    });

                            //  Construct JSX expr, 
                            similarJsx = <Accordion>
                                            <Card.Text>
                                                <Accordion.Toggle as={Button} variant="link" eventKey={screenName}>Tweets most like @{screenName}</Accordion.Toggle>
                                                <Accordion.Collapse eventKey={screenName}>
                                                    <Table size="sm">
                                                        <tbody>{ topSimilar }</tbody>
                                                    </Table>
                                                </Accordion.Collapse>
                                            </Card.Text>
                                        </Accordion>;
                        }

                        //  Badge color for % similarity indicator
                        const roundPct = this.roundPctExpr(similarityDetails.avg_similarity_score);

                        return(
                            <Card bg="light">
                                <Card.Body>
                                    <Card.Title>
                                        <Table borderless size="sm">
                                            <colgroup><col style={{width: 50}}></col><col></col></colgroup>
                                            <tr>
                                                <td><Image src={metaDetails.profile_img} rounded/></td>
                                                <td>{metaDetails.name}<br/><Badge variant={this.badgeColor(roundPct)}>{roundPct}% Match</Badge></td>
                                            </tr>
                                        </Table>
                                    </Card.Title>
                                    <Card.Subtitle className="mb-2 text-muted">
                                        <b>@{screenName}</b><br/>
                                        { metaDetails.description }
                                    </Card.Subtitle>
                                    { similarJsx }
                                </Card.Body>
                            </Card>
                        );
                    });

        return( 
            <CardColumns>
                { cardEntries }
            </CardColumns>
        );
    }


}

export { GroupDetails };

