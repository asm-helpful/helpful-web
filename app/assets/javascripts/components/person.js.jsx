/** @jsx React.DOM */

var Person = React.createClass({
  render: function() {
    return (
      <div className="person">
        <Avatar person={this.props.person} size={'small'} />
        <strong>{this.props.person.email}</strong>
      </div>
    );
  }
});
