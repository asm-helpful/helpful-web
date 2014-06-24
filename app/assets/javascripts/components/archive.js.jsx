/** @jsx React.DOM */

var Archive = React.createClass({
  render: function() {
    return <ConversationList accountSlug={this.props.accountSlug} archived={true} />;
  }
});
