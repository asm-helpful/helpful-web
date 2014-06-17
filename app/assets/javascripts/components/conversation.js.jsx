/** @jsx React.DOM */

var Conversation = React.createClass({


  render: function() {
    var unreadStatus = '';
    var urgentStatus = '';
    var replyStatus = '';

    var firstMessage = '';
    var conversationStream = '';
    var conversationResponse = '';

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
            <div className="conversation-status">
              {unreadStatus}
              {urgentStatus}
              {replyStatus}
            </div>

            <div className="conversation-summary">
              <ConversationParticipantList creator={this.props.conversation.creator_person} participants={this.props.conversation.participants} />

              <div className="conversation-summary-subject">
                {this.props.conversation.subject}
              </div>

              <div className="conversation-summary-body">
                {this.props.conversation.stream_items[0].content}
              </div>
            </div>

            <div className="conversation-actions">
              <button className="btn btn-default" onClick={this.props.laterConversationHandler}>
                Later
              </button>

              <button className="btn btn-default" onClick={this.props.archiveConversationHandler}>
                Archive
              </button>
            </div>

            <div className="conversation-avatars">
              <Avatar person={this.props.conversation.creator_person} />
            </div>

            <ConversationTagList tags={this.props.conversation.tags} />

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
  }
});
