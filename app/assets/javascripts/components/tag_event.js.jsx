/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.item.user.path}>
          <Avatar person={this.props.item.user.person} />
        </a>

        <strong>
          <a href={this.props.item.user.search_path}>
            {this.props.item.user.person.name}
          </a>

          {' '} tagged
        </strong>

        {' '} this conversation with {' '}

        <a href={this.props.item.search_path} className="tag">
          #{this.props.item.tag}
        </a>

        {' '} {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.item.updated_at).fromNow();
  }
});
