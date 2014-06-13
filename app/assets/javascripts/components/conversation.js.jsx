/** @jsx React.DOM */

var Conversation = React.createClass({
  getInitialState: function() {
    return {
      messagesVisible: false
    };
  },

  render: function() {
    return (
      <div className="list-item" key={this.props.conversation.id}>
        <div className={this.conversationClassNames()}>
          <div className="summary" onClick={this.toggleMessages}>
            <Avatar initials={this.props.conversation.creator_person.initials} gravatarUrl={this.props.conversation.creator_person.gravatar_url} />

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

            {this.state.messagesVisible ? <Message message={this.props.conversation.stream_items[0]} detail={false} /> : ''}
          </div>

          {this.state.messagesVisible ? <ConversationStream items={this.props.conversation.stream_items} /> : ''}
          {this.state.messagesVisible ? <ConversationResponse conversation={this.props.conversation} /> : ''}
        </div>
      </div>
    );
  },

  // TODO: scroll to conversation reply field
  // TODO: hide other open conversations
  toggleMessages: function(event) {
    event.preventDefault();
    event.stopPropagation();

    this.setState({
      messagesVisible: !this.state.messagesVisible
    });
  },

  conversationClassNames: function() {
    if(this.state.messagesVisible) {
      return ['conversation', 'conversation-detail'].join(' ');
    } else {
      return ['conversation', 'conversation-row'].join(' ');
    }
  }
});
