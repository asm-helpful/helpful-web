/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <div className="pull-right">{this.timestamp()}</div>

        <Avatar person={this.props.user.person} size="20" />
        <Person person={this.props.user.person} />
        &nbsp;tagged this with&nbsp;
        <a href="#" className="label label-default">
          #{this.props.tag}

          <span onClick={this.props.removeTagHandler(this.props)} className="geomicon geomicon-delete"></span>
        </a>
      </div>
    );
  },

  timestamp: function() {
    return moment(this.props.created).format("h:mma D/M/YYYY");
  }
});
