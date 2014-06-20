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
        <i className="ss-reply"></i>
      );
    }
  },

  renderActionBar: function() {
    return (
      <div className="conversation-action-bar clearfix">
        <div className="conversation-actions btn-group pull-right">
          <button className="btn btn-default btn-sm" onClick={this.props.laterHandler}>Later</button>
          <button className="btn btn-default btn-sm" onClick={this.props.archiveHandler}>Archive</button>
        </div>
      </div>
    );
  },

  renderActions: function() {
    return (
      <div className="conversation-actions btn-group pull-right">
        <button className="btn btn-default btn-sm" onClick={this.props.laterHandler}>Later</button>
        <button className="btn btn-default btn-sm" onClick={this.props.archiveHandler}>Archive</button>
      </div>
    );
  },

  renderSubject: function() {
    return (
      <div className="conversation-subject">
        <div className="conversation-gutter">
          {this.renderStatus()}
        </div>

        {this.props.conversation.subject}
      </div>
    );
  },

  renderPreview: function() {
    return (
      <div className="conversation-preview">
        <div className="conversation-gutter">
          <Avatar person={this.props.conversation.creator_person} size={'small'} />
        </div>

        <Person person={this.props.conversation.creator_person} />
    
        <div>
          <div className="conversation-gutter">
            {this.renderReply()}
          </div>
          <div className="conversation-preview-content" dangerouslySetInnerHTML={{__html: this.preview()}} />
        </div>
      </div>
    );
  },

  renderStream: function() {
    return (
      <div className="conversation-stream">
        <Stream items={this.props.conversation.stream_items} />
      </div>
    );
  },

  renderResponse: function() {
    return (
      <div className="conversation-response">
        <Response conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
      </div>
    );
  },

  render: function() {
    if(!this.props.conversation.expanded) {
      return (
        <div className="conversation">
          <a href="#" onClick={this.props.expandHandler}>
            {this.renderActions()}
            {this.renderSubject()}
            {this.renderPreview()}
          </a>
        </div>
      );
    } else {
      return (
        <div className="conversation active">
          <a href="#" onClick={this.props.collapseHandler}>
            {this.renderActionBar()}
          </a>
          {this.renderSubject()}
          {this.renderStream()}
          {this.renderResponse()}
        </div>
      );
    }
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
