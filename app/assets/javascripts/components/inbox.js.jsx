/** @jsx React.DOM */

var Inbox = React.createClass({
  render: function() {
    return <ConversationList accountSlug={this.props.accountSlug} archived={false} />;
  }
});
