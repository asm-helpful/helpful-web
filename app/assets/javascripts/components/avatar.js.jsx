/** @jsx React.DOM */

var Avatar = React.createClass({
  render: function() {
    avatarInitialsStyle = { width: 30, height: 30, lineHeight: '30px', display: 'none' };

    return (
      <div className="avatar avatar-default">
        <div className="avatar-initials" style={avatarInitialsStyle}>{this.props.initials}</div>
        <img src={this.props.gravatarUrl} width="30" height="30" onError={this.toggleAvatar} />
      </div>
    );
  },

  toggleAvatar: function(event) {
    var $img = $(event.target);
    $img.hide();
    $img.siblings().show();
  }
});
