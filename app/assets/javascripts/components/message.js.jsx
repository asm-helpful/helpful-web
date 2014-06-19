/** @jsx React.DOM */

var Message = React.createClass({
  render: function() {
    return (
      <div className="message">
        <div className="message-person"><Person person={this.props.message.person} /></div>
        <div className="message-content" dangerouslySetInnerHTML={{__html: this.markdownContent()}} />
      </div>
    );
  },

  markdownContent: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.message.content);
  }
});
