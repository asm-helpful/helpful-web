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
      function() {
        $notice = $('<div class="alert alert-success">').text('Successfully tagged the conversation with #' + match.value);
        $notice.append(
          $('<button type="button" class="close" data-dismiss="alert">').html('&times;')
        );

        $('.conversation-reply').prepend($notice);
      },
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
      function() {
        $notice = $('<div class="alert alert-success">').text('Successfully assigned the conversation to @' + match.value);
        $notice.append(
          $('<button type="button" class="close" data-dismiss="alert">').html('&times;')
        );

        $('.conversation-reply').prepend($notice);
      },
      'json'
    );
  };

  var useCannedResponse = function(match) {
    var account = $("[name='account-slug']").val();
    var cannedResponsePath = '/' + account + '/canned_responses/' + match.id;

    $.getJSON(
      cannedResponsePath,
      function(cannedResponse) {
        $('.conversation-reply textarea').val(cannedResponse.message);
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

var toggleSendButton = function(event) {
  var $textarea = $(this);
  var $sendButton = $('.command-bar :submit');

  if($textarea.val().length > 0) {
    $sendButton.show();
  } else {
    $sendButton.hide();
  }
};

$(document).on('ready page:load', function() {
  $textarea = $('.conversation-reply textarea');
  applyTextcomplete($textarea);
  $($textarea).keyup(toggleSendButton);
  toggleSendButton.bind($textarea)();
});
