/** @jsx React.DOM */

var Archive = React.createClass({
  render: function() {
    return (
      <div className="row">
        <div className="col-md-8 col-md-offset-2">
          <ConversationList accountSlug={this.props.accountSlug} archived={true} />;
        </div>
      </div>
    );
  }
});
