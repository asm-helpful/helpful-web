/** @jsx React.DOM */

var Message = React.createClass({
  renderReply: function() {
    if(this.props.person.agent) {
      return (
        <div className="reply">
          <span className="geomicon ss-reply"></span>
        </div>
      );
    }
  },

  render: function() {
    return (
      <div className="message">
        <small className="pull-right text-muted">
          {this.created()}
        </small>
        <div className="message-person">
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
