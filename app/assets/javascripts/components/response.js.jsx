/** @jsx React.DOM */

var Response = React.createClass({
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
      this.setState({ currentUser: response.user });
    }.bind(this));
  },

  initMediumEditor: function() {
    var $response = $('.medium-editor');
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
        content: $('.medium-editor').html()
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
    $('.medium-editor').html('');
  },

  useCannedResponseHandler: function(cannedResponse) {
    $('.medium-editor').html(cannedResponse.rendered_message);
    $('.medium-editor').removeClass('medium-editor-placeholder');
    $('.medium-editor').focus();
  },

  render: function() {
    return (
      <form className="form" onSubmit={this.createMessage}>
        <div className="form-group">
          <div className="form-control form-control-invisible medium-editor" placeholder="Write your reply..."></div>
        </div>

        <div className="form-actions">
          <div className="pull-right">
            <input className="btn btn-secondary" type="submit" name="commit" value="Send" />
          </div>

          <div className="btn-group">
            <AssignmentButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
            <TagButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
            <CannedResponseButton conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} useCannedResponseHandler={this.useCannedResponseHandler} />
          </div>
        </div>
      </form>
    );
  }
});
