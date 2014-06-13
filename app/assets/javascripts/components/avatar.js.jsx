/** @jsx React.DOM */

var Avatar = React.createClass({
  render: function() {
    avatarInitialsStyle = { width: 30, height: 30, lineHeight: '30px', display: 'none' };

    return (
      <div className="avatar avatar-default">
        <div className="avatar-initials" style={avatarInitialsStyle}>{this.props.person.initials}</div>
        <img src={this.props.person.gravatar_url} width="30" height="30" onError={this.avatarFailedToLoad} />
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    if(nextProps.person.gravatar_url !== this.props.person.gravatar_url) {
      this.showAvatar($('img', this.getDOMNode()));
    }
  },

  avatarFailedToLoad: function(event) {
    this.showInitials($(event.target));
  },

  showInitials: function($img) {
    $img.hide();
    $img.siblings().show();
  },

  showAvatar: function($img) {
    $img.show();
    $img.siblings().hide();
  }
});
