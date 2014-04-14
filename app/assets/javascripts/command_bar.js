var applyTextcomplete = function($element) {
  var textcompletesPath = $element.attr('data-textcomplete-path');

  var strategies =  [{
    match: /(^|\s)((#|@|:)\w*)$/,

    search: function(query, callback) {
      $.getJSON(textcompletesPath, { query: query })
        .done(function(response) {
          callback(response['textcompletes']);
        })
        .fail(function() {
          callback([]);
        });
    },

    replace: function(match) {
      return match.value; 
    },

    template: function(match) {
      return match.value;
    }
  }];

  var eventHandlers = {
    'textComplete:select': function(e, value) {
      alert(value);
    }
  };

  $element.textcomplete(strategies).on(eventHandlers);
};

$(document).ready(function() {
  applyTextcomplete($('.conversation-reply textarea'));
});
