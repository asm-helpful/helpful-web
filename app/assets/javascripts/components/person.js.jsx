/** @jsx React.DOM */

var Person = React.createClass({
  render: function() {
    return (
      <div className="person">
        <span className="person-avatar">
          <Avatar person={this.props.person} size={'small'} />
        </span>
        {this.props.person.email}
      </div>
    );
  }
});
