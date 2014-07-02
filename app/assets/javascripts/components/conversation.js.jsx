/** @jsx React.DOM */

var Conversation = React.createClass({
  renderStatus: function() {
    var isUnread = this.isUnread();
    var isStale = this.isStale();

    if(isUnread || isStale) {
      var classes = React.addons.classSet({
        'status': true,
        'status-unread': !isStale && isUnread,
        'status-urgent': isStale
      });

      return (
        <div className={classes}></div>
      );
    }
  },

  renderActions: function() {
    if(this.props.conversation.archived) {
      return (
        <div className="conversation-actions btn-group pull-right">
          <button className="btn btn-default btn-sm" onClick={this.props.unarchiveHandler}>Move to Inbox</button>
        </div>
      );
    } else {
      return (
        <div className="conversation-actions btn-group pull-right">
          <button className="btn btn-default btn-sm" onClick={this.props.archiveHandler}>Archive</button>
        </div>
      );
    }
  },

  renderReply: function() {
    if(this.hasReply() && !this.props.conversation.expanded) {
      return (
        <div className="reply">
          <span className="geomicon ss-reply"></span>
        </div>
      );
    }
  },

  renderHeader: function() {
    var previewBody = null;

    if(!this.props.conversation.expanded) {
      previewBody = <span className="text-muted" dangerouslySetInnerHTML={{__html: this.preview()}} />;
    }

    return (
      <a href="#" onClick={this.props.toggleHandler}>
        <div className="conversation-header">
          {this.renderStatus()}

          {this.renderActions()}
          <div className="conversation-person">
            <Person person={this.props.conversation.creator_person} />
          </div>

          <div className="conversation-preview">
            {this.renderReply()}

            <div className="ellipsis-overflow">
              {this.props.conversation.subject}
              &nbsp;
              {previewBody}
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
            <Stream items={this.streamItems()} />
          </div>

          <div className="conversation-response">
            <Response conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} archiveHandler={this.props.archiveHandler} />
          </div>
        </div>
      );
    }
  },

  render: function() {
    var classes = React.addons.classSet({
      'conversation': true,
      'is-expanded': this.props.conversation.expanded,
      'is-collapsed': !this.props.conversation.expanded
    });

    return (
      <div className={classes}>
        {this.renderHeader()}
        {this.renderBody()}
      </div>
    );
  },

  streamItems: function() {
    var items = _.flatten([
      this.props.conversation.messages,
      this.props.conversation.assignment_events,
      this.props.conversation.tag_events
    ])

    return _.sortBy(items, function(item) { return item.created });
  },

  // TODO: Implement read receipts
  isUnread: function() {
    return this.props.conversation.unread;
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
