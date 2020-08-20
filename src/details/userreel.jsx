import React from 'react';
import { Button, Badge, Table, CardColumns, Card, Image  } from 'react-bootstrap';


//  # of users to display in list
const NUM_ELEMENTS = 12;

class UserReel extends React.Component {

    //
    //  -- Properties --
    //  this.props.screenMeta (all covered users)
    //  this.props.handleUserSearch (func to handle screen name selection on user reel)
    //

    //  Why isn't there an easier way to do this I don't know.
    chooseNRandomArr = (arr, n) => {        
        n = Math.min(n, arr.length);
        let selectedArr = [];
        while (selectedArr.length < n) {
            const randidx = Math.floor((Math.random() * n));
            if (!selectedArr.includes(arr[randidx])) {
                selectedArr.push(arr[randidx]);
            };
        };
        return selectedArr;
    }

    //  For readability scores
    roundNumExpr = (rawNum) => {
        const scaled = Math.round(rawNum * 10) / 10;  // 1 dec point
        return scaled;
    }


    render() {

        // Get random N ppl in full set to highlight
        const selectedNames = this.chooseNRandomArr(Object.keys(this.props.screenMeta), NUM_ELEMENTS);
        
        const reelElems = selectedNames.map((screenName) => {
                const metaDetails = this.props.screenMeta[screenName];
                return(
                    <Card bg="light">
                    <Card.Body>
                        <Card.Title>
                            <Table borderless size="sm">
                                <colgroup><col style={{width: 50}}></col><col></col></colgroup>
                                <tr>
                                    <td>
                                        <a href="#" onClick={() => {this.props.handleUserSearch(screenName); } } style={{color:'inherit', textDecoration:'none'}}>
                                            <Image src={metaDetails.user.profile_img} rounded/></a>
                                    </td>
                                    <td>
                                        <a href="#" onClick={() => {this.props.handleUserSearch(screenName); } } style={{color:'inherit', textDecoration:'none'}}>
                                            {metaDetails.user.name}<br/>
                                            @{screenName}</a>
                                    </td>
                                </tr>
                            </Table>
                        </Card.Title>
                        <Card.Subtitle className="mb-2 text-muted">
                            { metaDetails.user.desc }<br/>
                            <Badge variant="light" style={{backgroundColor:'#99cccc'}}>Tweets at: Grade&nbsp; 
                                {
                                    this.roundNumExpr(metaDetails.readability.flesch_kincaid_grade_level) > 12 ? '12+' :
                                        Math.round(this.roundNumExpr(metaDetails.readability.flesch_kincaid_grade_level))
                                }
                            </Badge>
                        </Card.Subtitle>
                    </Card.Body>
                    </Card>
                );
        });

        return(
            <CardColumns>
                { reelElems }
            </CardColumns>
        );
    }

}

export { UserReel };
