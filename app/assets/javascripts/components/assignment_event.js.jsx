/** @jsx React.DOM */

var AssignmentEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.item.user.search_path}>
          <Avatar person={this.props.item.user.person} />
        </a>

        <strong>
          <a href={this.props.item.user.search_path}>
            {this.props.item.user.person.name}
          </a>

          {' '} assigned

          <a href={this.props.item.assignee.search_path}>
            <Avatar person={this.props.item.assignee.person} />

            {this.props.item.assignee.person.name}
          </a>
        </strong>

        {' '} to this conversation {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.item.updated_at).fromNow();
  }
});
