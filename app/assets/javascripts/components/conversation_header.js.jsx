/** @jsx React.DOM */

var ConversationHeader = React.createClass({
  render: function() {
    return (
      <div className="conversation-header">
        <Avatar person={this.props.conversation.creator} size="30"/>
        <Person person={this.props.conversation.creator} />
        <strong>{this.props.conversation.subject}</strong>
      </div>
    )
  }
})
