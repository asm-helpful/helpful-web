var getJSON = function getJSON(url, callback) {
  var request = new XMLHttpRequest()

  request.open('GET', url, true)

  request.onload = function() {
    if (this.status >= 200 && this.status < 400){
      callback(JSON.parse(this.response))
    }
  }

  request.send()
}
