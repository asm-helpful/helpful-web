/** @jsx React.DOM */
/*= require js-md5 */

var gravatarId = function gravatarId(email) {
  return md5(email.toLowerCase());
}

var Avatar = React.createClass({
  render: function() {
    var size = this.props.size;

    if(size === 'small') {
      size = 26;
    }

    return (
      <img className="avatar" src={this.gravatarUrl(size * 2)} width={size} height={size} />
    );
  },

  gravatarUrl: function(size) {
    return "https://secure.gravatar.com/avatar/" + gravatarId(this.props.person.email) + "?d=mm&size=" + size + ".png"
  }
});
