/** @jsx React.DOM */

var AssignmentEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.assignmentEvent.user.search_path}>
          <Avatar person={this.props.assignmentEvent.user.person} />
        </a>

        <strong>
          <a href={this.props.assignmentEvent.user.search_path}>
            {this.props.assignmentEvent.user.person.name}
          </a>

          {' '} assigned

          <a href={this.props.assignmentEvent.assignee.search_path}>
            <Avatar person={this.props.assignmentEvent.assignee.person} />

            {this.props.assignmentEvent.assignee.person.name}
          </a>
        </strong>

        {' '} to this conversation {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.assignmentEvent.updated_at).fromNow();
  }
});
