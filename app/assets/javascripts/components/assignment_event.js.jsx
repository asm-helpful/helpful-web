/** @jsx React.DOM */

var AssignmentEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <Person person={this.props.user.person} />
        &nbsp;
        assigned
        &nbsp;
        <Person person={this.props.assignee.person} />
        &nbsp;
        to this conversation {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.updated_at).fromNow();
  }
});
