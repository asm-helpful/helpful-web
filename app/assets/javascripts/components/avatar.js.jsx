/** @jsx React.DOM */

var Avatar = React.createClass({
  render: function() {
    return (
      <div className="avatar avatar-default">
        <img src={this.props.person.gravatar_url} width="30" height="30" />
      </div>
    );
  }
});
