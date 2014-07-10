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
    if(this.props.person.name) {
      return (
        <span>{this.props.person.name}</span>
      )
    } else {
      return (
        <span>{this.props.person.email}</span>
      )
    }
  }
});
