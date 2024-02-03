import React from 'react';
import { Button, Badge, Table, Accordion, Container, Row, Col, CardColumns, Card, Image  } from 'react-bootstrap';

class GroupDetails extends React.Component {

    //  -- Upstream data, from parent (details main) --
    //      this.props.screenMeta
    //      this.props.groupMeta
    //      this.props.groupCalculation
    //      this.props.groupName   (note: this is a property, not an event handler)
    //      this.props.userScreenName   // user being evaluated 

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

    //  For readability scores
    roundNumExpr = (rawNum) => {
        const scaled = Math.round(rawNum * 10) / 10;  // 1 dec point
        return scaled;
    }
    
    //  Badge color spectrum, directed by score 0-100
    badgeColor = (value) => {
        const clr = (value >= 60 ? 'success' : ( value >= 25 ? 'warning' : ( value >= 10  ? 'info' : 'secondary' ) ) )
        return clr;
    }
    
    render() {

        //  No group selected or empty group calc details?  Return blank -- 
        if (this.props.groupName == null || this.props.groupCalculation == null || 
            Object.entries(this.props.groupCalculation) < 1 ) { 
            return(
                <Container fluid>
                    <Row><Col>Reading, comparing and thinking hard...</Col></Row>
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
                                                        <tr><td>
                                                            <b><Badge variant={this.badgeColor(score)}>{score}% Match</Badge></b><br/>
                                                            {similarityElem.text}
                                                        </td></tr>
                                                    );
                                    });

                            //  Construct JSX expr, 
                            similarJsx = <Accordion>
                                            <Card.Text>
                                                <Accordion.Toggle as={Button} variant="link" eventKey={screenName}>@{this.props.userScreenName}'s highest matching tweets</Accordion.Toggle>
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
                                                <td><a href={`http://www.twitter.com/${screenName}`} target="_blank" rel="noopener noreferrer">
                                                    <Image src={metaDetails.user.profile_img} rounded/></a></td>
                                                <td><a href={`http://www.twitter.com/${screenName}`} target="_blank" rel="noopener noreferrer" style={{color:'inherit', textDecoration:'none'}}>
                                                        {metaDetails.user.name}</a><br/>
                                                        <Badge variant={this.badgeColor(roundPct)}>{roundPct}% Match</Badge>
                                                </td>
                                            </tr>
                                        </Table>
                                    </Card.Title>
                                    <Card.Subtitle className="mb-2 text-muted">
                                        <b>@{screenName}</b><br/>
                                        { metaDetails.user.desc }<br/>
                                        <Badge variant="light" style={{backgroundColor:'#99cccc'}}>Tweets at: Grade&nbsp; 
                                                {
                                                    this.roundNumExpr(metaDetails.readability.flesch_kincaid_grade_level) > 12 ? '12+' :
                                                        Math.round(this.roundNumExpr(metaDetails.readability.flesch_kincaid_grade_level))
                                                }</Badge><br/>                                         
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

