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
        <span>
          <strong>{this.props.person.name}</strong>
        </span>
      )
    } else {
      return (
        <strong>{this.props.person.email}</strong>
      )
    }
  }
});
