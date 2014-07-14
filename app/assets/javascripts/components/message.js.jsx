/** @jsx React.DOM */

var Message = React.createClass({
  render: function() {
    return (
      <div className="message">
        <div className="message-header">
          <span className="pull-right text-muted">
            {this.created()}
          </span>
          <Avatar person={this.props.person} size="20" />
          <Person person={this.props.person} />
        </div>

        <div className="message-content" dangerouslySetInnerHTML={{__html: this.content()}} />
      </div>
    );
  },

  created: function() {
    return moment(this.props.created).format("LT L");
  },

  content: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.content);
  }
});
