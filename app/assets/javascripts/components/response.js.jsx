/** @jsx React.DOM */

var Response = React.createClass({
  componentDidMount: function() {
    this.initMediumEditor();
  },

  initMediumEditor: function() {
    var $response = $('.medium-editor');
    var editor = new MediumEditor($response, {
      placeholder: $response.attr('placeholder')
    });
  },

  sendMessage: function(event) {
    event.stopPropagation();
    event.preventDefault();

    this.createMessage();
  },

  // TODO: Include file attachments
  createMessage: function() {
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

  renderArchiveButton: function() {
    if(!this.props.conversation.archived) {
      return (
          <button className="btn btn-danger" onClick={this.props.archiveHandler}>Archive</button>
      );
    }
  },

  render: function() {
    return (
      <form className="form">
        <div className="form-group">
          <div className="form-control form-control-invisible medium-editor" placeholder="Write your reply..."></div>
        </div>

        <div className="form-actions">
          <div className="pull-right">
            <div className="btn-toolbar">
              {this.renderArchiveButton()}
              <button className="btn btn-primary" onClick={this.sendMessage}>Send</button>
            </div>
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
