/** @jsx React.DOM */

var Person = React.createClass({
  render: function() {
    return (
      <div className="person">
        {this.label()}
      </div>
    );
  },

  label: function() {
    return (
      <div>
        <span>{this.props.person.name}</span>
        &nbsp;
        <span className="text-muted">{this.props.person.email}</span>
      </div>
    );
  }
});
