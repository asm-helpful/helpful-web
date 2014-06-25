/** @jsx React.DOM */

var ConversationParticipantList = React.createClass({
  render: function() {
    var creatorName = null;
    var creatorEmail = null;
    var participants = null;

    if(this.props.creator.name) {
      creatorName = (
        <div className="conversation-creator-name">
          {this.props.creator.name}
        </div>
      );
    }

    creatorEmail = (
      <div className="conversation-creator-email">
        {this.props.creator.email}
      </div>
    );

    if(this.props.participants.length > 1) {
      participants = (
        <div className="conversation-participants-count">
          + {this.props.participants.length - 1} more
        </div>
      );
    }

    return (
      <div className="conversation-participants">
        {creatorName}
        {creatorEmail}
        {participants}
      </div>
    );
  }
});
