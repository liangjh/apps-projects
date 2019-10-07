import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';
import 'bootstrap/dist/css/bootstrap.css';

let PERSONA   = process.env.REACT_APP_PERSONA; PERSONA = (PERSONA == null ? 'Trump' : PERSONA)

ReactDOM.render(<App title={"Trumpspired"}/>, 
                document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();


//  Set page title, manifest, favicon
//  Will be different depending on site persona

function setmeta() {
    try {
        const favicon_url  = (PERSONA == 'Trump') ? '/favicon-trumpspired.ico' : '/favicon-brexitspired.ico';
        const manifest_url = (PERSONA == 'Trump') ? '/manifest-trumpspired.json' : '/manifest-brexitspired.json';
        const page_title = `${PERSONA}spired`;

        document.querySelector('#favicon-placeholder').setAttribute('href', favicon_url);
        document.querySelector('#manifest-placeholder').setAttribute('href', manifest_url);
        document.title = page_title;

    }
    catch (error) {        
    }
}
document.addEventListener("DOMContentLoaded", setmeta);
