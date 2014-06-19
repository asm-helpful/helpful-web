/** @jsx React.DOM */

var Stream = React.createClass({
  componentTypes: {
    'message': Message,
    'assignmentevent': AssignmentEvent,
    'tagevent': TagEvent
  },

  render: function() {
    return (
      <div className="stream">
        {this.props.items.map(function(item) {
          var component = this.componentTypes[item.type];
          return (
            <div className="stream-item">
              {component({ item: item, key: item.id })}
            </div>
          );
        })}
      </div>
    );
  }
});
