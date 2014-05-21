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
      return '';
    },

    template: function(match) {
      switch(match.type) {
        case 'tag':
          return 'Tag with <strong>#' + match.value + '</strong>';
        case 'assignment':
          return 'Assign to <strong>@' + match.value + '</strong>';
        case 'canned_response':
          return 'Replace with <strong>:' + match.value + '</strong>';
      }
    }
  }];

  var tagConversation = function(match) {
    var account = $("[name='account-slug']").val();
    var conversation = $("[name='conversation-number']").val();
    var tagConversationPath = '/' + account + '/' + conversation + '/tags';

    $.post(
      tagConversationPath,
      { tag: match.value },
      function() { window.location.reload(); },
      'json'
    );
  };

  var assignConversation = function(match) {
    var account = $("[name='account-slug']").val();
    var conversation = $("[name='conversation-number']").val();
    var conversationPath = '/' + account + '/' + conversation;

    $.post(
      conversationPath,
      { conversation: { user_id: match.user_id }, _method: 'patch' },
      function() { window.location.reload(); },
      'json'
    );
  };

  var useCannedResponse = function(match) {
    var account = $("[name='account-slug']").val();
    var cannedResponsePath = '/' + account + '/canned_responses/' + match.id;

    $.getJSON(
      cannedResponsePath,
      function(cannedResponse) {
        $reply_message.html(cannedResponse.message);
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

$(document).on('ready page:load', function() {
  $reply_message = $('[data-reply-to-message]');

  if (!$reply_message.length)
    return;

  applyTextcomplete($reply_message);
});
