/** @jsx React.DOM */

var Message = React.createClass({
  renderReply: function() {
    if(this.props.person.agent) {
      return (
        <div className="reply">
          <i className="ss-reply"></i>
        </div>
      );
    }
  },

  render: function() {
    return (
      <div className="message">
        <div className="message-person">
          <Person person={this.props.person} />
        </div>
        {this.renderReply()}
        <div className="message-content" dangerouslySetInnerHTML={{__html: this.content()}} />
      </div>
    );
  },

  content: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.content);
  }
});
