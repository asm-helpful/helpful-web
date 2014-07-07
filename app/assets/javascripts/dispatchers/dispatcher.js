var _callbacks = []
var _promises = []

var Dispatcher = {}

Dispatcher.register = function(callback) {
  _callbacks.push(callback)
  return _callbacks.length - 1
}

Dispatcher.dispatch = function(payload) {
  var resolves = []
  var rejects = []

  _promises = _callbacks.map(function(_, i) {
    return new Promise(function(resolve, reject) {
      resolves[i] = resolve
      rejects[i] = reject
    })
  })

  _callbacks.forEach(function(callback, i) {
    Promise.resolve(callback(payload)).then(function() {
      resolves[i](payload)
    }, function() {
      rejects[i](new Error('Dispatcher callback unsuccessful'))
    })
  })

  _promises = []
}

Dispatcher.waitFor = function(promiseIndexes, callback) {
  var selectedPromises = promiseIndexes.map(function(index) {
    return _promises[index]
  })

  return Promise.all(selectedPromises).then(callback)
}
