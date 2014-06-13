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

  // TODO: Include file attachments
  createMessage: function(event) {
    event.preventDefault();
    event.stopPropagation();

    var data = {
      message: {
        conversation_id: this.props.conversation.id,
        content: $('.conversation-response').html()
      }
    };

    $.ajax({
      type: 'POST',
      url: this.props.conversation.create_message_path,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      accepts: { json: 'application/json' },
      success: function(response) {
        this.addMessage(response.message);
        this.clearResponse();
      }.bind(this)
    });
  },

  addMessage: function(message) {
    this.props.addMessageHandler(message);
  },

  clearResponse: function() {
    $('.conversation-response').html('');
  },

  // TODO: Include all command bar functions (assignment, tag, canned response)
  render: function() {
    return (
      <div className="conversation-response-container" onSubmit={this.createMessage}>
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
