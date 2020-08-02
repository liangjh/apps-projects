import React from 'react';
// import { Route, BrowserRouter as Router, Switch, Redirect } from 'react-router-dom';
import axios from 'axios';

class GroupDetails extends React.Component {

    //  -- Upstream data, from parent (details main) --
    //      this.props.screenMeta
    //      this.props.groupMeta
    //      this.props.groupCalculation
    //      this.props.groupName   (note: this is a property, not an event handler)

    constructor(props) {
        super(props);
        
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
       return(
        <div>
            <div> 
                { Object.keys(this.props.groupMeta) }
            </div>
            <div>
                { Object.keys(this.props.groupCalculation) }
            </div>
        </div>
       );
    }


}

export { GroupDetails };

