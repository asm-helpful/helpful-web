/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
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

      this.setState({ conversations: conversations });
    }.bind(this));
  },

  // TODO: This is terrible; Use React.addons.update()
  // TODO: Ignore clicks on content
  toggleMessagesHandler: function(visibleIndex) {
    var newConversations = this.state.conversations.map(function(conversation, index) {
      var toggleConversation = visibleIndex === index;
      conversation.messagesVisible = toggleConversation && !conversation.messagesVisible;
      return conversation;
    });

    this.setState({ conversations: newConversations });
  },

  // TODO: This is terrible; Use React.addons.update()
  addStreamItemHandler: function(index, streamItem) {
    this.state.conversations[index].stream_items.push(streamItem);
    this.replaceState(this.state);
  },

  // TODO: This is terrible; Use React.addons.update()
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

  moveToBottom: function(conversation) {
    var conversations = this.state.conversations;
    var index = conversations.indexOf(conversation);
    delete conversations[index];
    conversations.push(conversation);

    this.setState({
      conversations: conversations
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

  moveToArchive: function(conversation) {
    var conversations = this.state.conversations;
    var index = conversations.indexOf(conversation);
    delete conversations[index];

    this.setState({
      conversations: conversations
    });
  },

  render: function() {
    return (
      <div className="list list-conversations">
        {this.state.conversations.map(function(conversation, index) {
          var toggleMessages = function() {
            this.toggleMessagesHandler(index);
          }.bind(this);

          var addStreamItem = function(streamItem) {
            this.addStreamItemHandler(index, streamItem);
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
  }
});
