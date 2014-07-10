/** @jsx React.DOM */

var AssignmentEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <div className="pull-right">{this.timestamp()}</div>

        <Person person={this.props.user.person} />
        &nbsp;
        assigned this to
        &nbsp;
        <Person person={this.props.assignee.person} />
      </div>
    );
  },

  timestamp: function() {
    return moment(this.props.created).format("h:mma D/M/YYYY");
  }
});
