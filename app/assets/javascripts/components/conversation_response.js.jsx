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
        currentUser: response.user
      });
    }.bind(this));
  },

  initMediumEditor: function() {
    var $response = $('.conversation-response');
    var editor = new MediumEditor($response, {
      placeholder: $response.attr('placeholder')
    });
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
        this.addStreamItem(response.message);
        this.clearResponse();
      }.bind(this)
    });
  },

  addStreamItem: function(streamItem) {
    this.props.addStreamItemHandler(streamItem);
  },

  clearResponse: function() {
    $('.conversation-response').html('');
  },

  useCannedResponseHandler: function(cannedResponse) {
    $('.conversation-response').html(cannedResponse.rendered_message);
    $('.conversation-response').removeClass('medium-editor-placeholder');
    $('.conversation-response').focus();
  },

  render: function() {
    return (
      <div className="conversation-response-container" onSubmit={this.createMessage}>
        <Avatar person={this.state.currentUser.person} />

        <form>
          <div className="conversation-response" placeholder="Write your reply..."></div>

          <div className="command-bar">
            <div className="pull-left">
              <AssignmentButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
              <TagButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
              <CannedResponseButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} useCannedResponseHandler={this.useCannedResponseHandler} />
            </div>

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
