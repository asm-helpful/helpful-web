//= require underscore
//= require dispatchers/dispatcher

function add(conversation) {
  _inbox[conversation.id] = conversation
}

function update(id, updates) {
  _inbox[id] = _.extend(_inbox[id], updates)
}

function updateAll(updates) {
  for(var i in _inbox) {
    _inbox[i] = _.extend(_inbox[i], updates)
  }
}

var CHANGE_EVENT = 'CHANGE';

var InboxStore = {

  getAll: function() {
    return _inbox;
  },

  emitChange: function() {
    this.emit(CHANGE_EVENT);
  },

  addChangeListener: function(callback) {
    this.on(CHANGE_EVENT, callback);
  },

  removeChangeListener: function(callback) {
    this.removeListener(CHANGE_EVENT, callback);
  },

  // --

  emit: function(event) {
    var callbacks = this.listeners && this.listeners[event]
    for (var i = 0, l = callbacks.length; i < l; i++) {
      callbacks[i]()
    }
  },

  on: function(event, callback) {
    this.listeners = this.listeners || {}
    this.listeners[event] = this.listeners[event] || []
    this.listeners[event].push(callback)
    return this.listeners[event].length - 1
  },

  removeListener: function(event, eventIndex) {
    if (this.listeners && this.listeners[event]) {
      this.listeners[event].splice(index, 1)
      return this.listeners[event].length
    } else {
      return -1
    }
  },

  // --

  dispatcherIndex: Dispatcher.register(function(action) {

    console.log('inboxStore', action.actionType)

    switch(action.actionType) {
      case 'CONVERSATION_ROW_OPEN':
        updateAll({open: false})
        update(action.id, {open: true})
        InboxStore.emitChange()
        break

      case 'CONVERSATION_ROW_CLOSE':
        update(action.id, {open: false})
        InboxStore.emitChange()
        break

      default:
        return true
    }

    return true
  })

}
