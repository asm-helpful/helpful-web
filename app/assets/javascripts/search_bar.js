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
          $('.search-results-container').html(
            searchResultsTemplate(results)
          )
        }
      );
    }, 200);
  });
};

var clearInputButton = function($element) {
  var $clearButton = $element.siblings('.glyphicon-remove');

  $clearButton.click(function() {
    $element.val('').blur();
    return false;
  });
};

var toggleHighlight = function($element) {
  $element.focus(function() {  
    $(this).removeClass('filled');
  });

  $element.blur(function() {
    if(this.value.length > 0){
      $(this).addClass('filled');
    } else {
      $(this).removeClass('filled');
    }
  });
}

$(document).on('ready page:change', function() {
  $searchQuery = $('#search-query');

  if(!!$searchQuery.length) {
    searchConversations($searchQuery);
    clearInputButton($searchQuery);
    toggleHighlight($searchQuery);
  }
});
