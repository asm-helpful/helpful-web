/** @jsx React.DOM */
/*= require js-md5 */

var gravatarId = function gravatarId(email) {
  return md5(email.toLowerCase());
}

var Avatar = React.createClass({

  render: function() {
    return (
      <img className="avatar"
           src={this.gravatarUrl()}
           width={this.size()}
           height={this.size()}
      />
    );
  },

  // --

  size: function() {
    return this.props.size || 20;
  },

  retinaSize: function() {
    return this.size() * 2;
  },

  gravatarUrl: function() {
    return "https://secure.gravatar.com/avatar/" +
             gravatarId(this.props.person.email) +
             "?d=mm&size=" +
             this.retinaSize() +
             ".png"
  }
});
