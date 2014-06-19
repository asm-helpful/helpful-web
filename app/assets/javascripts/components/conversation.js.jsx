/** @jsx React.DOM */

var Conversation = React.createClass({
  render: function() {
    var unreadStatus = null;
    var urgentStatus = null;
    var replyStatus = null;
    //
    // TODO: Imeplement read receipts
    if(false) {
      unreadStatus = (
        <i className="unread-status"></i>
      );
    }

    if(this.stale()) {
      urgentStatus = (
        <i className="urgent-status"></i>
      );
    }

    if(this.props.conversation.messages.length > 1) {
      replyStatus = (
        <i className="reply-status ss-reply"></i>
      );
    }

    var stream = null;
    var conversationResponse = null;

    if(this.props.messagesVisible) { 
      stream = (
        <ConversationStream items={this.props.conversation.stream_items} />
      );

      conversationResponse = (
        <ConversationResponse conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
      );
    }

    return (
      <div className="conversation">
        <div className="pull-right">
          <button className="btn btn-link">Later</button>
          <button className="btn btn-link">Archive</button>
        </div>
      
        <div className="conversation-subject">
          {this.props.conversation.subject}
        </div>
          
        <div className="conversation-preview">
          <Message message={this.props.conversation.messages[0]} />
        </div>
      </div>
    );
    
    
  //   <div className="conversation-stream">{stream}</div>
  //   {conversationResponse}
  // </div>
  //   
  },

  conversationClassNames: function() {
    if(this.props.messagesVisible) {
      return ['conversation', 'conversation-detail'].join(' ');
    } else {
      return ['conversation', 'conversation-row'].join(' ');
    }
  },

  stale: function() {
    return !this.props.conversation.archived &&
      moment(this.props.conversation.last_activity_at) < moment().subtract('days', 3)
  }
});
