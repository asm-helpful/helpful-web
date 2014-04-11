var searchConversations = function($element) {
  var searchPath = $element.attr('data-search-path');
  var searchTimeout = null;
  var searchResultsTemplate = Handlebars.compile($('#search-results-template').html());

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
          $('#search-results').html(
            searchResultsTemplate(results)
          )
        }
      );
    }, 200);
  });

};

$(document).on('ready page:change', function() {
  searchConversations($('#search-query'));
});
