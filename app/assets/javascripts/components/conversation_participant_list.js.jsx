/** @jsx React.DOM */

var ConversationParticipantList = React.createClass({
  render: function() {
    var renderParticipant = function(participant) {
      return (
        <li key={participant.id}>
          {participant.nickname}
        </li>
      );
    };

    return (
      <ul className="participants">
        {this.props.participants.map(renderParticipant)}
      </ul>
    );
  }
});
