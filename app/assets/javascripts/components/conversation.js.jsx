/** @jsx React.DOM */

var Conversation = React.createClass({
  render: function() {
    var unreadStatus = null;
    var urgentStatus = null;
    var replyStatus = null;

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

    var firstMessage = null;
    var conversationStream = null;
    var conversationResponse = null;

    if(this.props.messagesVisible) { 
      firstMessage = (
        <Message message={this.props.conversation.stream_items[0]} detail={false} />
      );

      conversationStream = (
        <ConversationStream items={this.props.conversation.stream_items} />
      );

      conversationResponse = (
        <ConversationResponse conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
      );
    }

    return (
      <div className="list-item" key={this.props.conversation.id}>
        <div className={this.conversationClassNames()}>
          <div className="conversation-header" onClick={this.props.toggleMessagesHandler}>
            <div className="row">
              <div className="conversation-status">
                {unreadStatus}
                {urgentStatus}
                {replyStatus}
              </div>

              <div className="conversation-summary col-xs-9">
                <ConversationParticipantList creator={this.props.conversation.creator_person} participants={this.props.conversation.participants} />

                <div className="conversation-summary-subject">
                  {this.props.conversation.subject}
                </div>

                <div className="conversation-summary-body">
                  {this.props.conversation.stream_items[0].content}
                </div>
              </div>

              <div className="conversation-actions col-xs-2">
                <button className="btn btn-default" onClick={this.props.laterConversationHandler}>
                  Later
                </button>

                <button className="btn btn-default" onClick={this.props.archiveConversationHandler}>
                  Archive
                </button>
              </div>

              <div className="conversation-avatars col-xs-1">
                <Avatar person={this.props.conversation.creator_person} />
              </div>
            </div>

            {firstMessage}
          </div>

          {conversationStream}
          {conversationResponse}
        </div>
      </div>
    );
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
