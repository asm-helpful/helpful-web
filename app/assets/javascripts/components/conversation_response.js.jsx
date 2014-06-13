/** @jsx React.DOM */

var ConversationResponse = React.createClass({
  getInitialState: function() {
    return {
      currentUser: {
        person: {
          initials: '',
          gravatar_url: ''
        }
      }
    }
  },

  componentDidMount: function() {
    this.getCurrentUser();
    this.initMediumEditor();
  },

  getCurrentUser: function() {
    $.getJSON('/user', function(response) {
      this.setState({
        currentUser: response['user']
      });
    }.bind(this));
  },

  initMediumEditor: function() {
    var $response = $('.conversation-response');
    var editor = new MediumEditor($response, {
      placeholder: $response.attr('placeholder')
    });

    // Autofocus the response field after setting up the editor
    setTimeout(function() { $response.focus() }, 0);
  },

  // TODO: Submit response via ajax and insert message
  // TODO: Include all command bar functions (assignment, tag, canned response)
  render: function() {
    return (
      <div className="conversation-response-container">
        <Avatar person={this.state.currentUser.person} />

        <form>
          <div className="conversation-response" placeholder="Write your reply..."></div>

          <div className="command-bar">
            <div className="pull-right">
              <input className="btn btn-secondary" type="submit" name="commit" value="Send" />
            </div>
            <div className="clearfix"></div>
          </div>
        </form>  
      </div>
    );
  }
});
