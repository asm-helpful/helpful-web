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

    this.createMessage(false);
  },

  sendAndArchiveMessage: function(event) {
    event.stopPropagation();
    event.preventDefault();

    this.createMessage(true);
  },

  // TODO: Include file attachments
  createMessage: function(archiveConversation) {
    var data = {
      archive_conversation: archiveConversation,
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

        if(archiveConversation) {
          this.props.archiveHandler();
        }
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
      <form className="form">
        <div className="form-group">
          <div className="form-control form-control-invisible medium-editor" placeholder="Write your reply..."></div>
        </div>

        <div className="form-actions">
          <div className="pull-right">
            <div className="btn-group">
              <button type="button" className="btn btn-primary" onClick={this.sendMessage}>Send</button>
              <button type="button" className="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                <span className="caret"></span>
                <span className="sr-only">Toggle Dropdown</span>
              </button>
              <ul className="dropdown-menu" role="menu">
                <li>
                  <a href="#" onClick={this.sendAndArchiveMessage}>
                    Send &amp; Archive
                  </a>
                </li>
              </ul>
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
