/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
      loaded: false,
      conversations: [],
      archived: this.props.archived
    };
  },

  componentDidMount: function() {
    if(this.props.conversationNumber) {
      this.getConversation();
    } else {
      this.getConversations();
    }
  },

  getConversation: function() {
    $.getJSON(this.conversationPath(), function(response) {
      this.setState({ archived: response.conversation.archived });
      this.getConversations();
    }.bind(this));
  },

  getConversations: function() {
    $.getJSON(this.conversationsPath(), function(response) {
      var conversations = response.conversations;

      conversations = conversations.map(function(conversation) {
        conversation.expanded = (this.props.conversationNumber == conversation.number)
        return conversation;
      }.bind(this));

      this.setState({
        loaded: true,
        conversations: conversations
      });
    }.bind(this));
  },

  toggleHandler: function(toggled) {
    return function(event) {
      event.stopPropagation();
      event.preventDefault();

      var conversations = this.state.conversations.map(function(conversation) {
        if(conversation === toggled) {
          var expanded = !conversation.expanded;
          conversation.expanded = expanded;

          // TODO: Remove nested conditionals
          if(expanded) {
            conversation.unread = false;
            this.read(conversation);
            router.navigate(conversation.path);
          } else {
            if(conversation.archived) {
              router.navigate(this.archivePath());
            } else {
              router.navigate(this.inboxPath());
            }
          }
        } else {
          conversation.expanded = false;
        }

        return conversation;
      }.bind(this));

      this.setState({ conversations: conversations });
    }.bind(this);
  },

  read: function(conversation) {
    $.getJSON(conversation.path)
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

  archiveHandler: function(conversation) {
    return function(event) {
      event.stopPropagation();
      event.preventDefault();

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
    conversation.expanded = false;

    var index = this.state.conversations.indexOf(conversation);
    var conversations = this.state.conversations.slice(0, index).
      concat(this.state.conversations.slice(index + 1));

    this.setState({ conversations: conversations });

    this.updateRoute(conversation);
  },

  unarchiveHandler: function(conversation) {
    return function(event) {
      event.stopPropagation();
      event.preventDefault();

      var data = {
        conversation: {
          unarchive: true
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

  moveToInbox: function(conversation) {
    conversation.expanded = false;

    var index = this.state.conversations.indexOf(conversation);
    var conversations = this.state.conversations.slice(0, index).
      concat(this.state.conversations.slice(index + 1));

    this.setState({ conversations: conversations });

    this.updateRoute(conversation);
  },

  renderConversation: function(conversation) {
    if(conversation.messages.length > 0) {
      return Conversation({
        conversation: conversation,
        toggleHandler: this.toggleHandler(conversation),
        addStreamItemHandler: this.addStreamItemHandler(conversation),
        archiveHandler: this.archiveHandler(conversation),
        unarchiveHandler: this.unarchiveHandler(conversation),
        key: conversation.id
      });
    }
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
  },

  updateRoute: function(conversation) {
    if(conversation.expanded) {
      router.navigate(conversation.path);
    } else if(conversation.archived) {
      router.navigate(this.archivePath());
    } else {
      router.navigate(this.inboxPath());
    }
  },

  inboxPath: function() {
    return '/' + this.props.accountSlug + '/inbox';
  },

  archivePath: function() {
    return '/' + this.props.accountSlug + '/archived';
  },

  conversationsPath: function() {
    return '/accounts/' + this.props.accountSlug + '/conversations.json?archived=' + this.state.archived;
  },

  conversationPath: function() {
    return '/accounts/' + this.props.accountSlug + '/conversations/' + this.props.conversationNumber + '.json';
  }
});
