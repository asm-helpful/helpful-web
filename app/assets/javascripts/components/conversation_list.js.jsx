/** @jsx React.DOM */

var ConversationList = React.createClass({
  getInitialState: function() {
    return {
      conversations: []
    };
  },

  componentDidMount: function() {
    $.getJSON(this.props.source, function(response) {
      this.setState({
        conversations: response['conversations']
      });
    }.bind(this));
  },

  render: function() {
    return (
      <div className="list list-conversations">
        {this.state.conversations.map(function(conversation) {
          return <Conversation conversation={conversation} />
        })}
      </div>
    );
  }
});
