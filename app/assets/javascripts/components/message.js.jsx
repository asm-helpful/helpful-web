/** @jsx React.DOM */

var Message = React.createClass({
  render: function() {
    return (
      <div className="message">
        <div className="message-person"></div>
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
    return converter.makeHtml(this.props.item.content);
  },

  previewContent: function() {
    return $(this.markdownContent()).text();
  }
});
