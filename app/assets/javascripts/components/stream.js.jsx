/** @jsx React.DOM */

var Stream = React.createClass({
  renderStreamItem: function(item) {
    var component = this.componentForType(item.type);

    return (
      <div className="stream-item">
        {component({ item: item, key: item.id })}
      </div>
    );
  },

  render: function() {
    return (
      <div className="stream">
        {this.props.items.map(this.renderStreamItem)}
      </div>
    );
  },

  componentForType: function(type) {
    return {
      'message': Message,
      'assignmentevent': AssignmentEvent,
      'tagevent': TagEvent
    }[type];
  }
});
