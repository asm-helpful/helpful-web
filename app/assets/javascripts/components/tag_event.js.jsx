/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <div className="pull-right">{this.timestamp()}</div>

        <Person person={this.props.user.person} />
        &nbsp;
        tagged this with
        &nbsp;
        <a href={this.props.user.search_path} className="label label-default">
          #{this.props.tag}
        </a>
      </div>
    );
  },

  timestamp: function() {
    return moment(this.props.created).format("h:mma D/M/YYYY");
  }
});
