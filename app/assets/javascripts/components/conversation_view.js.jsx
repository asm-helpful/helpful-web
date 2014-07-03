/** @jsx React.DOM */

var ConversationView = React.createClass({
  getInitialState: function() {
    return {
      conversation: null,
      archived: false
    };
  },

  componentDidMount: function() {
    this.getConversation();
  },

  getConversation: function() {
    $.getJSON(this.conversationPath(), function(response) {
      var conversation = response.conversation;
      conversation.expanded = true;
      this.setState({ conversation: conversation, archived: conversation.archive });
    }.bind(this));
  },

  // TODO: Clean up duplication on ConversationList
  addStreamItemHandler: function(streamItem) {
    var conversation = this.state.conversation;

    switch(streamItem.type) {
      case 'message':
        conversation.messages.push(streamItem);
      break;
      case 'assignmentevent':
        conversation.assignment_events.push(streamItem);
      break;
      case 'tagevent':
        conversation.tag_events.push(streamItem);
      break;
    }

    this.setState({ conversation: conversation });
  },


  // TODO: Clean up duplication on ConversationList
  archiveHandler: function(event) {
    event.stopPropagation();
    event.preventDefault();

    var data = {
      conversation: {
        archive: true
      }
    };

    $.ajax({
      type: 'PUT',
      url: this.state.conversation.path,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      accepts: { json: 'application/json' },
      success: function(response) {
        var conversation = this.state.conversation;
        conversation.archived = true;
        this.setState({ conversation: conversation });
      }.bind(this)
    });
  },

  unarchiveHandler: function(event) {
    event.stopPropagation();
    event.preventDefault();

    var data = {
      conversation: {
        unarchive: true
      }
    };

    $.ajax({
      type: 'PUT',
      url: this.state.conversation.path,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      accepts: { json: 'application/json' },
      success: function(response) {
        var conversation = this.state.conversation;
        conversation.archived = false;
        this.setState({ conversation: conversation });
      }.bind(this)
    });
  },

  renderConversation: function() {
    return Conversation({
      conversation: this.state.conversation,
      toggleHandler: function() {},
      addStreamItemHandler: this.addStreamItemHandler,
      archiveHandler: this.archiveHandler,
      unarchiveHandler: this.unarchiveHandler,
      key: this.state.conversation.id
    });
  },

  renderMailboxLink: function() {
    if(this.state.archived) {
      return (
        <a href="#" className="text-muted">
          <span className="glyphicon glyphicon-chevron-left"></span>
          Back to Archive 
        </a>
      );
    } else {
      return (
        <a href="#" className="text-muted">
          <span className="glyphicon glyphicon-chevron-left"></span>
          Back to Inbox
        </a>
      );
    }
  },

  render: function() {
    if(this.state.conversation && this.state.conversation.messages.length > 0) {
      return (
        <div>
          {this.renderMailboxLink()}
          {this.renderConversation()}
        </div>
      );
    } else {
      return <div></div>;
    }
  },

  conversationPath: function() {
    return '/accounts/' + this.props.accountSlug + '/conversations/' + this.props.conversationNumber + '.json';
  }
});
