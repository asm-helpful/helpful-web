var searchConversations = function($element) {
  var searchPath = $element.attr('data-search-path');
  var searchTimeout = null;

  $element.keypress(function() {
    if(searchTimeout) {
      clearTimeout(searchTimeout);
    }

    searchTimeout = setTimeout(function() {
      $.getJSON(
        searchPath,
        {
          q: $element.val()
        },
        function(results) {
          $('#search-results').text(JSON.stringify(results));
        }
      );
    }, 200);
  });

};

$(document).on('ready page:change', function() {
  searchConversations($('#search-query'));
});
