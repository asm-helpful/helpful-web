/** @jsx React.DOM */

var Conversation = React.createClass({
  render: function() {
    return (
      <div className="list-item" key={this.props.conversation.id}>
        <div className={this.conversationClassNames()}>
          <div className="actions">
            <button className="btn btn-default" onClick={this.props.laterConversationHandler}>Later</button>
            <button className="btn btn-default" onClick={this.props.archiveConversationHandler}>Archive</button>
          </div>
          <div className="summary" onClick={this.props.toggleMessagesHandler}>
            <Avatar person={this.props.conversation.creator_person} />

            <div className="detail">
              <span className="badge badge-message-count">
                <span className="glyphicon glyphicon-envelope"></span>
                {this.props.conversation.message_count} 
              </span>

              <ConversationTimestamp archived={this.props.conversation.archived} lastActivityAt={this.props.conversation.last_activity_at} />

              <ConversationParticipantList participants={this.props.conversation.participants} />

              <div className="number">
                #{this.props.conversation.number}
              </div>
            </div>

            <div className="title">
              {this.props.conversation.summary}
            </div>

            <ConversationTagList tags={this.props.conversation.tags} />

            {this.props.messagesVisible ? <Message message={this.props.conversation.stream_items[0]} detail={false} /> : ''}
          </div>

          {this.props.messagesVisible ? <ConversationStream items={this.props.conversation.stream_items} /> : ''}
          {this.props.messagesVisible ? <ConversationResponse conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} /> : ''}
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
