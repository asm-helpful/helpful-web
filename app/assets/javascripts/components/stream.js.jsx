/** @jsx React.DOM */

var Stream = React.createClass({
  renderStreamItem: function(item) {
    var componentClass = this.componentForType(item.type);
    var attributes = item;

    if(item.type == 'tagevent') {
      attributes.removeTagHandler = this.props.removeTagHandler;
    }

    var streamItem = componentClass(attributes);

    return <div className="stream-item" key={item.id}>{streamItem}</div>
  },

  render: function() {
    var streamItems = this.props.items.map(this.renderStreamItem);

    return <div className="stream">{streamItems}</div>
  },

  componentForType: function(type) {
    return {
      'message': Message,
      'assignmentevent': AssignmentEvent,
      'tagevent': TagEvent
    }[type];
  }
});
