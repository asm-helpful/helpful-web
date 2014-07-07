/** @jsx React.DOM */

var Folder = React.createClass({

  propTypes: {
    conversations: React.PropTypes.object.isRequired
  },

  render: function() {
    var items = []
    for (var id in this.props.conversations) {
      var c = this.props.conversations[id]
      items.push(
        <div className="folder-item" key={id}>
          <ConversationRow conversation={c} />
        </div>
      )
    }

    return (
      <div className="folder">
        {items}
      </div>
    )
  }
})
