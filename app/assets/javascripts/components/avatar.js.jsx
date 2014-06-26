/** @jsx React.DOM */

var Avatar = React.createClass({
  render: function() {
    var size = this.props.size;

    if(size === 'small') {
      size = 20;
    }

    return (
      <img className="avatar" src={this.props.person.gravatar_url} width={size} height={size} />
    );
  }
});
