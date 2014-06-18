/** @jsx React.DOM */

var ConversationStreamItem = React.createClass({
  render: function() {
    return this.componentForType(this.props.item.type);
  },

  componentForType: function(type) {
    switch(type) {
      case 'message':
        return this.messageComponent();
      case 'tagevent':
        return this.tagEventComponent();
      case 'assignmentevent':
        return this.assignmentEventComponent();
    }
  },

  messageComponent: function() {
    return (
      <Message message={this.props.item} key={this.props.item.id} />
    )
  },

  tagEventComponent: function() {
    return (
      <TagEvent tagEvent={this.props.item} key={this.props.item.id} />
    )
  },

  assignmentEventComponent: function() {
    return (
      <AssignmentEvent assignmentEvent={this.props.item} key={this.props.item.id} />
    )
  }
});
