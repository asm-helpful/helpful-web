/** @jsx React.DOM */

var Message = React.createClass({
  render: function() {
    return (
      <div className="message">
        {this.props.detail ? <Avatar initials={this.props.message.person.initials} gravatarUrl={this.props.message.person.gravatar_url} /> : ''}

        {this.props.detail ? <div className="person">{this.props.message.person.nickname}</div> : ''}

        <div className="content" dangerouslySetInnerHTML={{__html: this.markdownContent()}} />
      </div>
    );
  },

  markdownContent: function() {
    var converter = new Showdown.converter();
    return converter.makeHtml(this.props.message.content);
  }
});
