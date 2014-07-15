/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
      loaded: false,
      conversations: [],
      archived: this.props.archived,
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
        }

        return conversation;
      });

      this.setState({ conversations: conversations });
    }.bind(this);
  },

  archiveHandler: function(conversation) {
    return function(event) {
      if(event) {
        event.stopPropagation();
        event.preventDefault();
      }

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

      return (
        <div className="row">
          <div className="col-md-8 col-md-offset-2">
            <div className="list list-conversations">{conversations}</div>
          </div>
        </div>
      )
    } else if(this.state.loaded) {
      if (this.state.archived || this.props.query || this.props.tag || this.props.assignee) {
        return <EmptyConversationList />
      }
      else {
        return <InboxZero />
      }
    } else {
      return <div></div>
    }
  },

  inboxPath: function() {
    return '/' + this.props.accountSlug + '/inbox';
  },

  archivePath: function() {
    return '/' + this.props.accountSlug + '/archived';
  },

  conversationsPath: function() {
    var path = [];
    path.push('/accounts/');
    path.push(this.props.accountSlug);
    path.push('/conversations.json');

    if(this.props.query || this.props.tag || this.props.assignee) {
      if(this.props.query) {
        path.push('?q=');
        path.push(encodeURIComponent(this.props.query));
      } else if(this.props.tag) {
        path.push('?tag=');
        path.push(encodeURIComponent(this.props.tag));
      } else if(this.props.assignee) {
        path.push('?assignee=');
        path.push(encodeURIComponent(this.props.assignee));
      }
    } else {
      path.push('?archived=');
      path.push(this.state.archived);
    }

    return path.join('');
  },

  conversationPath: function() {
    return '/accounts/' + this.props.accountSlug + '/conversations/' + this.props.conversationNumber + '.json';
  }
});
