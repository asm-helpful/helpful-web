/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
      loaded: false,
      conversations: [],
      currentUser: {
        person: {
          initials: '',
          gravatar_url: ''
        }
      }
    };
  },

  componentDidMount: function() {
    this.getConversations();
  },

  getConversations: function() {
    $.getJSON(this.props.source, function(response) {
      var conversations = response.conversations;

      conversations = conversations.map(function(conversation) {
        conversation.expanded = false;
        return conversation;
      });

      this.setState({
        loaded: true,
        conversations: conversations
      });
    }.bind(this));
  },

  expandHandler: function(expanded) {
    return function(event) {
      var conversations = this.state.conversations.map(function(conversation) {
        conversation.expanded = conversation === expanded
        return conversation;
      });

      this.setState({ conversations: conversations });
    }.bind(this);
  },

  collapseHandler: function(event) {
    var conversations = this.state.conversations.map(function(conversation) {
      conversation.expanded = false;
      return conversation;
    });

    this.setState({ conversations: conversations });
  },

  addStreamItemHandler: function(addedTo) {
    return function(streamItem) {
      var conversations = this.state.conversations.map(function(conversation) {
        if(conversation === addedTo) {
          conversation.stream_items.push(streamItem);
        }

        return conversation;
      });

      this.setState({ conversations: conversations });
    }.bind(this);
  },

  laterHandler: function(conversation) {
    return function(event) {
      event.stopPropagation();

      var data = {
        conversation: {
          respond_later: true
        }
      };

      $.ajax({
        type: 'PUT',
        url: conversation.path,
        data: JSON.stringify(data),
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.moveToBottom(conversation);
        }.bind(this)
      });
    }.bind(this);
  },

  moveToBottom: function(conversation) {
    var index = this.state.conversations.indexOf(conversation);
    var conversations = this.state.conversations.slice(0, index).
      concat(this.state.conversations.slice(index + 1)).
      concat(conversation);

    this.setState({ conversations: conversations });
  },

  archiveHandler: function(conversation) {
    return function(event) {
      event.stopPropagation();

      var data = {
        conversation: {
          archive: true
        }
      };

      $.ajax({
        type: 'PUT',
        url: conversation.path,
        data: JSON.stringify(data),
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.moveToArchive(conversation);
        }.bind(this)
      });
    }.bind(this);
  },

  moveToArchive: function(conversation) {
    var index = this.state.conversations.indexOf(conversation);
    var conversations = this.state.conversations.slice(0, index).
      concat(this.state.conversations.slice(index + 1));

    this.setState({ conversations: conversations });
  },

  renderConversation: function(conversation) {
    return Conversation({
      conversation: conversation,
      expandHandler: this.expandHandler(conversation),
      collapseHandler: this.collapseHandler,
      addStreamItemHandler: this.addStreamItemHandler(conversation),
      laterHandler: this.laterHandler(conversation),
      archiveHandler: this.archiveHandler(conversation),
      currentUser: this.state.currentUser,
      key: conversation.id
    });
  },

  render: function() {
    if(this.state.conversations.length) {
      var conversations = this.state.conversations.map(this.renderConversation);
      return <div className="list list-conversations">{conversations}</div>
    } else if(this.state.loaded) {
      return <InboxZero />
    } else {
      return <div></div>
    }
  }
});
