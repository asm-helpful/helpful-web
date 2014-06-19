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

  render: function() {
    var header = (
      <div className="conversation-header">
        <div className="btn-group pull-right">
          <button className="btn btn-default btn-sm">Later</button>
          <button className="btn btn-default btn-sm">Archive</button>
        </div>

        <div className="conversation-subject">
          <div className="conversation-gutter">
            {this.renderStatus()}
          </div>
  
          {this.props.conversation.subject}
        </div>
      </div>
    );

    // var stream = (
    //   <div className="conversation-stream">
    //     <Stream items={this.props.conversation.stream_items.slice(1)} />
    //   </div>
    // );
    // 
    // var response = (
    //   <div className="conversation-response">
    //     <Response conversation={this.props.conversation} addStreamItemHandler={this.props.addStreamItemHandler} />
    //   </div>
    // );
  
    var preview = (
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

    var conversation = null;
    
    if(!this.props.messagesVisible) {
      conversation = (
        <a href="#" onClick={this.props.toggleMessagesHandler}>
          {header}
          {preview}
        </a>
      );
    } else {
      conversation = (
        <div>
          {header}
          {stream}
          {response}
        </div>
      );
    }
    
    return (
      <div className="conversation">
        {conversation}
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
    return true;
  },
  
  preview: function() {
    var converter = new Showdown.converter();
    return $(converter.makeHtml(this.props.conversation.messages[0].content)).text();
  }
});
