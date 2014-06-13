/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.tagEvent.user.path}>
          <Avatar person={this.props.tagEvent.user.person} />
        </a>

        <strong>
          <a href={this.props.tagEvent.user.search_path}>
            {this.props.tagEvent.user.person.name}
          </a>

          {' '} tagged
        </strong>

        {' '} this conversation with {' '}

        <a href={this.props.tagEvent.search_path} className="tag">
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
