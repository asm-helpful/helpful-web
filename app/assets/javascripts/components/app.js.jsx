/** @jsx React.DOM */
//= require stores/inbox_store
//= require components/folder

function getState() {
  return {
    inbox: InboxStore.getAll(),
  }
}

var App = React.createClass({

  getInitialState: function() {
    return getState()
  },

  componentDidMount: function() {
    InboxStore.addChangeListener(this._onChange)
  },

  componentWillUnmount: function() {
    InboxStore.removeChangeListener(this._onChange)
  },

  render: function() {
    return (
      <div className="container">
        <Folder conversations={this.state.inbox} />
      </div>
    )
  },

  // --

  _onChange: function() {
    this.setState(getState())
  }
})
