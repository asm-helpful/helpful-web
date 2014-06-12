/** @jsx React.DOM */

var Conversation = React.createClass({
  render: function() {
    return (
      <div className="list-item" key={this.props.conversation.id}>
        <a href={this.props.conversation.url} className="conversation conversation-row">
          <div className="summary">
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
          </div>
        </a>
      </div>
    );
  }
});
