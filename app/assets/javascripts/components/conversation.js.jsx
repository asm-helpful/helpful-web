/** @jsx React.DOM */

var Conversation = React.createClass({
  renderStatus: function() {
    var isUnread = this.isUnread();
    var isStale = this.isStale();

    if(isUnread || isStale) {
      var classes = React.addons.classSet({
        'status': true,
        'status-unread': isUnread,
        'status-urgent': isStale
      });

      return (
        <div className={classes}></div>
      );
    }
  },

  renderReply: function() {
    if(this.hasReply()) {
      return (
        <div className="reply">
          <i className="ss-reply"></i>
        </div>
      );
    }
  },

  renderHeader: function() {
    return (
      <a href="#" onClick={this.props.toggleHandler}>
        <div className="conversation-header">
          {this.renderStatus()}        

          <div className="conversation-actions btn-group pull-right">
            <button className="btn btn-default btn-sm" onClick={this.props.laterHandler}>Later</button>
            <button className="btn btn-default btn-sm" onClick={this.props.archiveHandler}>Archive</button>
          </div>

          <div className="conversation-person">
            <Avatar person={this.props.conversation.creator_person} size={'small'} />
            <Person person={this.props.conversation.creator_person} />
          </div>

          <div className="conversation-preview">
            {this.renderReply()}

            <div className="ellipsis-overflow">
              {this.props.conversation.subject}
              &nbsp;
              <span className="text-muted" dangerouslySetInnerHTML={{__html: this.preview()}} />
            </div>
          </div>
        </div>
      </a>
    );
  },

  renderBody: function() {
    if(this.props.conversation.expanded) {
      return (
        <div className="conversation-body">
          <div className="conversation-stream">
            <Stream items={this.props.conversation.stream_items} />
          </div>

          <div className="conversation-response">
            <Response conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
          </div>
        </div>
      );
    }
  },

  render: function() {
    var classes = React.addons.classSet({
      'conversation': true,
      'conversation-expanded': this.props.conversation.expanded
    });

    return (
      <div className={classes}>
        {this.renderHeader()}
        {this.renderBody()}
      </div>
    );
  },

  // TODO: Implement read receipts
  isUnread: function() {
    return false;
  },

  isStale: function() {
    return !this.props.conversation.archived &&
      moment(this.props.conversation.last_activity_at) < moment().subtract('days', 3)
  },

  hasReply: function() {
    return this.props.conversation.messages.length > 1;
  },

  preview: function() {
    var converter = new Showdown.converter();
    return $(converter.makeHtml(this.props.conversation.messages[0].content)).text();
  }
});
