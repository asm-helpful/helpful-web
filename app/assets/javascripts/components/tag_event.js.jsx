/** @jsx React.DOM */

var TagEvent = React.createClass({
  render: function() {
    return (
      <div className="event">
        <Person person={this.props.user.person} />
        &nbsp;
        tagged this conversation with
        &nbsp;
        <a href={this.props.user.search_path} className="label label-default">
          #{this.props.tag}
        </a>
        &nbsp;
        {this.timeAgoInWords()}
      </div>
    );
  },

  timeAgoInWords: function() {
    return moment(this.props.updated_at).fromNow();
  }
});
