/** @jsx React.DOM */

var ConversationRow = React.createClass({

  render: function() {
    var body;
    if(this.props.conversation.open) {
      body = (
        <div>Open!</div>
      )
    }

    return (
      <div className="conversation-row">
        <a onClick={this._onToggleOpen}>
          <ConversationHeader conversation={this.props.conversation} />
        </a>
        <div className="quick-actions">
          <a className="btn btn-link btn-xs" href="#">Archive</a>
        </div>
        {body}
      </div>
    )
  },

  _onToggleOpen: function() {
    ConversationRowActions.toggleOpen(this.props.conversation)
  }
})

// <div className="conversation-header">
//   {this.renderStatus()}
//
//   {this.renderActions()}
//   <div className="conversation-person">
//     <Person person={this.props.conversation.creator_person} />
//   </div>
//
//   <div className="conversation-preview">
//     {this.renderReply()}
//
//     <div className="ellipsis-overflow">
//       {this.props.conversation.subject}
//       &nbsp;
//       {previewBody}
//     </div>
//   </div>
// </div>
