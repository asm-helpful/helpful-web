/** @jsx React.DOM */

var Message = React.createClass({
  renderReply: function() {
    if(this.props.person.agent) {
      return (
        <div className="reply">
          <span className="geomicon geomicon-reply"></span>
        </div>
      );
    }
  },

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

        {this.renderReply()}
        <div className="message-content" dangerouslySetInnerHTML={{__html: this.content()}} />
      </div>
    );
  },

  created: function() {
    return moment(this.props.created).format("h:mma D/M/YYYY");
  },

  content: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.content);
  }
});
