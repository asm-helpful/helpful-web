/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
      conversationsLoaded: false,
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
        conversation.messagesVisible = false;
        return conversation;
      });

      this.setState({
        conversationsLoaded: true,
        conversations: conversations
      });
    }.bind(this));
  },

  // TODO: Ignore clicks on content
  toggleMessagesHandler: function(toggledConversation) {
    var toggledConversations = this.state.conversations.map(function(conversation) {
      if(conversation === toggledConversation) {
        conversation.messagesVisible = !conversation.messagesVisible;
      } else {
        conversation.messagesVisible = false;
      }

      return conversation;
    });

    this.setState({
      conversations: toggledConversations
    });
  },

  addStreamItemHandler: function(updatedConversation, streamItem) {
    var updatedConversations = this.state.conversations.map(function(conversation) {
      if(conversation === updatedConversation) {
        conversation.stream_items.push(streamItem);
      }

      return conversation;
    });

    this.setState({
      conversations: updatedConversations
    });
  },

  laterConversationHandler: function(conversation) {
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
  },

  moveToBottom: function(movedConversation) {
    var conversations = this.state.conversations;
    var index = conversations.indexOf(movedConversation);
    var reorganizedConversations = conversations.slice(0, index).
      concat(conversations.slice(index + 1)).
      concat(movedConversation);

    this.setState({
      conversations: reorganizedConversations
    });
  },

  archiveConversationHandler: function(conversation) {
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
  },

  moveToArchive: function(movedConversation) {
    var conversations = this.state.conversations;
    var index = conversations.indexOf(movedConversation);
    var unarchivedConversations = conversations.slice(0, index).
      concat(conversations.slice(index + 1));

    this.setState({
      conversations: unarchivedConversations
    });
  },

  render: function() {
    if(!!this.state.conversations.length) {
      return (
        <div className="list list-conversations">
          {this.state.conversations.map(function(conversation) {
            var toggleMessages = function() {
              this.toggleMessagesHandler(conversation);
            }.bind(this);

            var addStreamItem = function(streamItem) {
              this.addStreamItemHandler(conversation, streamItem);
            }.bind(this);

            var laterConversation = function(event) {
              this.laterConversationHandler(conversation);
            }.bind(this);

            var archiveConversation = function(event) {
              this.archiveConversationHandler(conversation);
            }.bind(this);

            return (
              <Conversation
                conversation={conversation}
                currentUser={this.state.currentUser}
                messagesVisible={conversation.messagesVisible}
                toggleMessagesHandler={toggleMessages}
                addStreamItemHandler={addStreamItem}
                laterConversationHandler={laterConversation}
                archiveConversationHandler={archiveConversation}
                key={conversation.id} />
            );
          }.bind(this))}
        </div>
      );
    } else if(this.state.conversationsLoaded) {
      return (
        <InboxZero />
      );
    } else {
      return (
        <div></div>
      );
    }
  }
});
