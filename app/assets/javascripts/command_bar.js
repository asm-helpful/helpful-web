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
  var $divider = $('li.divider', $dropdown);
  var searchType = $dropdownToggle.attr('data-search');
  var searchTimeout;
  var actionResultTemplate = Handlebars.compile($('#action-result-template').html());

  $input.keyup(function() {
    $divider.nextAll().show();
    $('[data-suggestion="true"]', $btnGroup).remove();

    var inputValue = $input.val();
    if (inputValue == "") {
      return;
    }

    var inputRegexp = new RegExp(inputValue, 'gi');
    $divider.nextAll().each(function() {
      var $anchor = $(this).children('a');
      var value = $anchor.attr('data-value');

      if (!value.match(inputRegexp)) {
        $(this).hide();
      }
    });

    if (searchType == 'tags' && !$('a[data-value="' + inputValue + '"]').length) {
      $divider.after(actionResultTemplate({ value: inputValue, suggestion: true }));
    }
  });

  $btnGroup.on('click', 'li a', function(e) {
    e.preventDefault();
    e.stopPropagation();

    switch(searchType) {
      case 'assignments':
        assignConversation($(this));
        break;
      case 'tags':
        tagConversation($(this));
        break;
      case 'canned_responses':
        useCannedResponse($(this));
        break;
    };

    return false;
  });

  var resetCommandBar = function() {
    $dropdownToggle.dropdown('toggle');
    $input.val('');
  }

  var tagConversation = function($anchor) {
    var account = $("[name='account-slug']").val();
    var conversation = $("[name='conversation-number']").val();
    var tagConversationPath = '/' + account + '/' + conversation + '/tags';
    var tagEventTemplate = Handlebars.compile($('#tag-event-template').html());

    $.post(
      tagConversationPath,
      { tag: $anchor.attr('data-value') },
      function(response) {
        $('.conversation-stream').append(tagEventTemplate(response.tag_event))
        resetCommandBar();
      },
      'json'
    );
  };

  var assignConversation = function($anchor) {
    var account = $("[name='account-slug']").val();
    var conversation = $("[name='conversation-number']").val();
    var assignConversationPath = '/' + account + '/' + conversation + '/assignee';
    var assignmentEventTemplate = Handlebars.compile($('#assignment-event-template').html());

    $.post(
      assignConversationPath,
      { assignee_id: $anchor.attr('data-user-id') },
      function(response) {
        $('.conversation-stream').append(assignmentEventTemplate(response.assignment_event))
        resetCommandBar();
      },
      'json'
    );
  };

  var useCannedResponse = function($anchor) {
    var $replyMessage = $('[data-reply-to-message]');
    var account = $("[name='account-slug']").val();
    var cannedResponsePath = '/' + account + '/canned_responses/' + $anchor.attr('data-id');

    $.getJSON(
      cannedResponsePath,
      function(response) {
        $replyMessage.html(response.canned_response.rendered_message);
        $replyMessage.removeClass('medium-editor-placeholder');
        $replyMessage.focus();
        resetCommandBar();
      }
    );
  };
};


$(function() {
  $('.command-bar-action').each(function() {
    applyCommandBarActions($(this));
  });

  $('.dropdown-menu input').click(function(e) {
    e.stopPropagation();
  });

  // TODO: change this for a generic function that triggers file inputs
  $('#message_attachments_atributes_trigger').click(function(){
    $('#message_attachments_atributes').trigger('click');

    $('#message_attachments_atributes').change(function(){
      $('#message_attachments_atributes_trigger').find('span.counter').html(
        $("#message_attachments_atributes").get(0).files.length
      )
    });

    return false;
  });
});
