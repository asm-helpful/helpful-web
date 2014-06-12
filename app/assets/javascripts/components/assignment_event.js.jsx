/** @jsx React.DOM */

var AssignmentEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <a href={this.props.assignmentEvent.user_url}>
          <Avatar initials={this.props.assignmentEvent.initials} gravatarUrl={this.props.assignmentEvent.avatar_url} />
        </a>

        <strong>
          <a href={this.props.assignmentEvent.user_url}>
            {this.props.assignmentEvent.name}
          </a>

          {' '} assigned

          <a href={this.props.assignmentEvent.assignee_url}>
            <Avatar initials={this.props.assignmentEvent.assignee_initials} gravatarUrl={this.props.assignmentEvent.assignee_avatar_url} />

            {this.props.assignmentEvent.assignee_name}
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
