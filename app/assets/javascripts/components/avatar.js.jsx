/** @jsx React.DOM */

var Avatar = React.createClass({
  render: function() {
    var classes = React.addons.classSet({
      'avatar': true,
      'avatar-small': this.props.size === 'small',
      'avatar-default': !('size' in this.props)
    });

    return (
      <div className={classes}>
        <img src={this.props.person.gravatar_url} width="30" height="30" />
      </div>
    );
  }
});
