/** @jsx React.DOM */

var Message = React.createClass({
  render: function() {
    return (
      <div className="message">
        <div className="person">{this.props.message.person.nickname}</div>
        <Avatar person={this.props.message.person} />
        <div className="content" dangerouslySetInnerHTML={{__html: this.markdownContent()}} />
      </div>
    );
  },

  markdownContent: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.message.content);
  }
});
