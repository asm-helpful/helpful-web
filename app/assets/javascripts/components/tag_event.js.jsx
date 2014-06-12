/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.tagEvent.user_url}>
          <Avatar initials={this.props.tagEvent.initials} gravatarUrl={this.props.tagEvent.avatar_url} />
        </a>

        <strong>
          <a href={this.props.tagEvent.user_url}>
            {this.props.tagEvent.name}
          </a>

          {' '} tagged
        </strong>

        {' '} this conversation with {' '}

        <a href={this.props.tagEvent.tag_url} className="tag">
          #{this.props.tagEvent.tag}
        </a>

        {' '} {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.tagEvent.updated_at).fromNow();
  }
});
