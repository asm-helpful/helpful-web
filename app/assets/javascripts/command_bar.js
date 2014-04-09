var strategy = function(textcompleteSearchPath) {
  return [{
    match: /(^|\s)((#|@|:)\w*)$/,

    search: function(term, callback) { 
      if (term === "") {
        callback([]);
        return;
      }

      $.getJSON(textcompleteSearchPath, { q: term })
        .done(function(response) {
          callback(response['textcomplete_searches']);
        })
        .fail(function() {
          callback([]);
        });
    },

    replace: function(value) {
      return value; 
    }
  }];
};

$(document).ready(function() {
  var $replyTextarea = $('.conversation-reply textarea')
  var textcompleteSearchPath = $replyTextarea.attr('data-textcomplete-search-path');

  $replyTextarea.textcomplete(strategy(textcompleteSearchPath));
});
