function applyCommandBarActions($btnGroup) {
  autofocusInput($btnGroup);
  applyTextcomplete($btnGroup);
};

function autofocusInput($btnGroup) {
  var $dropdownToggle = $('.dropdown-toggle', $btnGroup);
  var $input = $('input', $btnGroup);

  $dropdownToggle.click(function() {
    setTimeout(function() {
      $input.focus();
    }, 0);
  });

  $input.click(function(e) {
    e.stopPropagation();
  });
}

function applyTextcomplete($btnGroup) {
  var textcompletesPath = $btnGroup.attr('data-textcomplete-path');
  var $input = $('input', $btnGroup);
  var $dropdownToggle = $('.dropdown-toggle', $btnGroup);
  var $dropdown = $('.dropdown-menu', $btnGroup);
  var searchType = $dropdownToggle.attr('data-search'); 

  var strategies =  [{
    match: /(^|\s)(\w*)$/,

    search: function(query, callback) {
      $.getJSON(textcompletesPath, { query: query, query_type: searchType })
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
      return match.value;
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

  $input.textcomplete(strategies, { appendTo: $dropdown }).on(eventHandlers);
};


$(document).on('ready page:load', function() {
  $('.command-bar-action').each(function() {
    applyCommandBarActions($(this));
  });

  $('.dropdown-menu input').click(function(e) {
    e.stopPropagation();
  });
});
