/** @jsx React.DOM */

var Inbox = React.createClass({
  render: function() {
    return (
      <div className="row">
        <div className="col-md-8 col-md-offset-2">
          <ConversationList accountSlug={this.props.accountSlug} archived={false} />;
        </div>
      </div>
    );
  }
});
