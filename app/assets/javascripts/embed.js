// Supportly Embed JS

// When somebody with an Account includes a script tag to this file on their own
// website, it'll embed a simple web popup that posts to Supportly.

var supportFooEmbed = (function() {
    var supportFooEmbedMethods = {};
    var body = document.getElementsByTagName('body')[0];
    var supportButton = document.createElement('button');
    supportButton.setAttribute('id', 'supportFooButton');
    supportButton.setAttribute('style', 'color: #FFF; font-weight: bold; background-color: #E5674A; border: 1px solid #DC4320; bottom: 20px; right: 20px; position: fixed; height: 50px; width: 100px; cursor: pointer; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;');
    supportButton.setAttribute('onClick', 'supportFooEmbed.popupModal()');
    var buttonText = document.createTextNode('Help!');
    supportButton.appendChild(buttonText);
    body.appendChild(supportButton);

    supportFooEmbedMethods.popupModal = function() {
        var body = document.getElementsByTagName('body')[0];
        var bodyCover = document.createElement('div');
        bodyCover.setAttribute('id', 'supportFooModalBackground');
        bodyCover.setAttribute('style', 'background-color: #333333; height: 10000px; left: 0; opacity: 0.4; filter:alpha(opacity=40); overflow: hidden; position: absolute; top: 0; width: 100%;')
        body.appendChild(bodyCover);

        var modal = document.createElement('div');
        modal.setAttribute('id', 'supportFooModal');
        modal.setAttribute('style', 'background-color: #eaeaea; height: 800px; left: 50%; border: 1px solid #333333; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; margin-left: -300px; margin-top: -400px; position: fixed; top: 50%; width: 600px; z-index: 99;');

        var modalBody = document.createElement('div');
        modalBody.setAttribute('id', 'supportFooModalBody');
        modalBody.setAttribute('style', 'height: 100%; position: relative; width: 100%;');
        modal.appendChild(modalBody);

        var modalClose = document.createElement('a');
        modalClose.setAttribute('id', 'supportFooModalClose');
        modalClose.setAttribute('style', 'cursor: pointer; position: absolute; right: 5px; top: 5px;');
        modalClose.setAttribute('onClick', 'supportFooEmbed.closeModal()');
        var modalCloseText = document.createTextNode('Close (X)');
        modalClose.appendChild(modalCloseText);
        modalBody.appendChild(modalClose);

        var modalTitle = document.createElement('h1');
        modalTitle.setAttribute('id', 'supportFooModalBody');
        modalTitle.setAttribute('style', 'font-size: 30px; text-align: center;');
        var titleText = document.createTextNode('Acme Support Widget');
        modalTitle.appendChild(titleText);
        modalBody.appendChild(modalTitle);

        body.appendChild(modal);

    };

    supportFooEmbedMethods.closeModal = function() {
        var body = document.getElementsByTagName('body')[0];
        body.removeChild(document.getElementById('supportFooModalBackground'));
        body.removeChild(document.getElementById('supportFooModal'));
    }

    return supportFooEmbedMethods;

})();