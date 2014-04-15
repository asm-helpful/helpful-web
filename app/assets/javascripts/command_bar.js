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
    var account = $("meta[name='account-slug']").attr('content');
    var conversation = $("meta[name='conversation-number']").attr('content');
    var tagConversationPath = '/' + account + '/' + conversation + '/tags';

    $.post(
      tagConversationPath,
      { tag: match.value },
      function() {
        console.log('tagConversation success');
        console.log(match);
        // displayTagEvent(match);
      },
      'json'
    );
  };

  var assignConversation = function(match) {
    var account = $("meta[name='account-slug']").attr('content');
    var conversation = $("meta[name='conversation-number']").attr('content');
    var conversationPath = '/' + account + '/' + conversation;

    $.post(
      conversationPath,
      { conversation: { user_id: match.user_id }, _method: 'patch' },
      function() {
        console.log('assignConversation success');
        console.log(match);
        // displayAssignmentEvent(match);
      },
      'json'
    );
  };

  var useCannedResponse = function(match) {
    var account = $("meta[name='account-slug']").attr('content');
    var cannedResponsePath = '/' + account + '/canned_responses/' + match.id;

    $.getJSON(
      cannedResponsePath,
      function(cannedResponse) {
        console.log('useCannedResponse success');
        console.log(cannedResponse);
        // replaceMessageWithCannedResponse(cannedRepsonse);
      }
    )
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
