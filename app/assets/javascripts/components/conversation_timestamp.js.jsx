/** @jsx React.DOM */

var ConversationTimestamp = React.createClass({
  render: function() {
    var lastActivityAtInWords = this.timeAgoInWords(this.props.lastActivityAt);

    return (
      <span className={this.timestampClassNames(this.props.archived, this.props.lastActivityAt)}>
        {lastActivityAtInWords}
      </span>
    );
  },

  timestampClassNames: function(archived, date) {
    var classes = ['timestamp'];

    if(!archived && moment(date) < moment().subtract('days', 3)) {
      classes.push('badge');
      classes.push('badge-timestamp-stale');
    }

    return classes.join(' ');
  },

  timeAgoInWords: function(date) {
    return moment(date).fromNow();
  }
});
