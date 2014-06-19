/** @jsx React.DOM */

var Person = React.createClass({
  render: function() {
    return (
      <div className="person">
        <div className="conversation-gutter">
          <Avatar person={this.props.person} size={'small'} />
        </div>
        <strong>{this.props.person.email}</strong>
      </div>
    );
  }
});
