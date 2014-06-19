/** @jsx React.DOM */

var Conversation = React.createClass({
  renderStatus: function() {
    var unread = this.unread();
    var stale = this.stale();

    if(unread || stale) {
      var classes = React.addons.classSet({
        'status': true,
        'status-unread': unread,
        'status-urgent': stale
      });

      return (
        <div className={classes}></div>
      );
    }
  },

  renderReplyStatus: function() {
    var reply = this.reply();

    if(reply) {
      var classes = React.addons.classSet({
        'status': true,
        'status-reply': true
      });

      return (
        <div className={classes}></div>
      );
    }
  },

  render: function() {

    var replyStatus = null;

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
          <div className="conversation-gutter">
            {this.renderStatus()}
          </div>
          {this.props.conversation.subject}
        </div>
          
        <div className="conversation-preview">
          <Person person={this.props.conversation.creator_person} />
          <Message message={this.props.conversation.messages[0]} reply={true} preview={true} />
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

  // TODO: Implement read receipts
  unread: function() {
    return false;
  },

  stale: function() {
    return !this.props.conversation.archived &&
      moment(this.props.conversation.last_activity_at) < moment().subtract('days', 3)
  },
});
