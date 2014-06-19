/** @jsx React.DOM */

var Message = React.createClass({
  renderReplyStatus: function() {
    if(this.props.reply) {
      var classes = React.addons.classSet({
        'status': true,
        'status-reply': true
      });

      return (
        <div className={classes}></div>
      );
    }
  },

  render: function() {
    return (
      <div className="message">
        <div className="conversation-gutter">
          {this.renderReplyStatus()}
        </div>
        <div className="message-content" dangerouslySetInnerHTML={{__html: this.content()}} />
      </div>
    );
  },

  content: function() {
    if(('preview' in this.props) && this.props.preview) {
      return this.previewContent();
    } else {
      return this.markdownContent();
    }
  },

  markdownContent: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.message.content);
  },

  previewContent: function() {
    return $(this.markdownContent()).text();
  }
});
