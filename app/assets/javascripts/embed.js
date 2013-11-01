// Supportly Embed JS

// When somebody with an Account includes a script tag to this file on their own
// website, it'll embed a simple web popup that posts to Supportly.

var supportFooEmbed = (function() {
    var supportFooEmbedMethods = {};
    var body = document.getElementsByTagName('body')[0];
    var supportButton = document.createElement('button');
    supportButton.setAttribute('id', 'supportFooButton');
    supportButton.setAttribute('style', 'background-color: #eaeaea; border: 1px solid #333333; bottom: 15px; cursor: pointer; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; height: 50px; position: fixed; right:15px; width: 150px;');
    supportButton.setAttribute('onClick', 'supportFooEmbed.popupModal()');
    var buttonText = document.createTextNode('Help!');
    supportButton.appendChild(buttonText);
    body.appendChild(supportButton);

    supportFooEmbedMethods.popupModal = function() {
        var body = document.getElementsByTagName('body')[0];
        var modal = document.createElement('div');
        modal.setAttribute('id', 'supportFooModal');
        modal.setAttribute('style', 'background-color: #eaeaea; height: 800px; left: 50%; border: 1px solid #333333; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; margin-left: -300px; margin-top: -400px; position: fixed; top: 50%; width: 600px; z-index: 1;');

        var modalBody = document.createElement('div');
        modalBody.setAttribute('id', 'supportFooModalBody');
        modalBody.setAttribute('style', 'height: 100%; width: 100%;');
        modal.appendChild(modalBody);

        var modalTitle = document.createElement('h1');
        modalTitle.setAttribute('id', 'supportFooModalBody');
        modalTitle.setAttribute('style', 'font-size: 30px; text-align: center;');
        var titleText = document.createTextNode('Acme Support Widget');
        modalTitle.appendChild(titleText);
        modalBody.appendChild(modalTitle);

        body.appendChild(modal);

    };
    return supportFooEmbedMethods;

})();