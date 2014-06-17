/** @jsx React.DOM */

var ConversationStream = React.createClass({
  render: function() {
    return (
      <div className="conversation-stream">
        {this.props.items.slice(1).map(function(item) {
          return <ConversationStreamItem item={item} key={item.id} />
        })}
      </div>
    );
  }
});
