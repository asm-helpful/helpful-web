// Supportly Embed JS

// When somebody with an Account includes a script tag to this file on their own
// website, it'll embed a simple web popup that posts to Supportly.

var body = document.getElementsByTagName('body')[0];
var supportButton = document.createElement('button');
supportButton.setAttribute('id', 'supportFooButton');
supportButton.setAttribute('style', 'background-color: #eaeaea; border: 1px solid #333333; bottom: 15px; cursor: pointer; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; height: 50px; position: fixed; right:15px; width: 150px;');
supportButton.setAttribute('onClick', 'popupModal()');
var buttonText = document.createTextNode('Help!');
supportButton.appendChild(buttonText);
body.appendChild(supportButton);

var popupModal = function() {
    var body = document.getElementsByTagName('body')[0];
    var modal = document.createElement('div');
    modal.setAttribute('id', 'supportFooModal');
    modal.setAttribute('style', 'background-color: #eaeaea; height: 300px; left: 50%; border: 1px solid #333333; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; margin-left: -150px; margin-top: -150px; position: fixed; top: 50%; width: 300px;');
    body.appendChild(modal);
};