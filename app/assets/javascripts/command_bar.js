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
      switch(match.type) {
        case 'tag':
          return 'Tag with <strong>' + match.value + '</strong>';
        case 'assignment':
          return 'Assign to <strong>' + match.value + '</strong>';
        case 'canned_response':
          return 'Replace with <strong>' + match.value + '</strong>';
      }
    }
  }];

  var tagConversation = function(match) {
    var tagConversationPath = '/conversations/' + conversationId + '/tags';

    $.post({
      url: tagConversationsPath,
      data: { tag: match.value },
      success: function() {
        displayTagEvent(match);
      }
    });
  };

  var assignConversation = function(match) {
    conversationPath = '/' + accountSlug + '/conversations/' + conversationId;

    $.post({
      url: conversationPath,
      data: { conversation: { user_id: match.user_id } },
      success: function() {
        displayAssignmentEvent(match);
      }
    });
  };

  var useCannedResponse = function(match) {
    var cannedResponsePath = '/' + accountSlug + '/canned_responess/' + match.id;

    $.getJSON()
  };

  var eventHandlers = {
    'textComplete:select': function(event, match) {

      switch(match.type) {
        case 'tag':
          tagConversation(match);
          break;
        case 'assignment':
          assignConversation(match);
          break;
        case 'canned_response':
          useCannedResponse(match);
          break;
      }
    }
  };

  $element.textcomplete(strategies).on(eventHandlers);
};

$(document).ready(function() {
  applyTextcomplete($('.conversation-reply textarea'));
});
