var conversations = {
  onRespondLaterClick: function() {
    var $listItem = $(this).parents('.conversation-row').parent();
    var path = $(this).attr('data-account-conversation-path');

    var pushToEndOfQueue = function() {
      var $list = $listItem.parent();
      $listItem.remove().appendTo($list);
    }

    $.post(path, { conversation: { respond_later: true }, _method: 'patch' }, pushToEndOfQueue);

    return false;
  },

  onArchiveClick: function() {
    var $listItem = $(this).parents('.conversation-row').parent();
    var path = $(this).attr('data-account-conversation-path');

    var removeFromQueue = function() {
      if ($listItem.siblings().length == 0) {
        $('.empty-state').removeClass('hide');        
      }
      $listItem.remove();
    }

    $.post(path, { conversation: { archive: true }, _method: 'patch' }, removeFromQueue);

    return false;
  }
}


$(document).ready(function() {
  $('.list').delegate('.respond-later', 'click', conversations.onRespondLaterClick);
  $('.list').delegate('.archive', 'click', conversations.onArchiveClick);
});
