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
        $('.empty-state').show();
      }
      $listItem.remove();
    }

    $.post(path, { conversation: { archive: true }, _method: 'patch' }, removeFromQueue);

    return false;
  }
}

$(document).on('ready page:load', function() {
  $('.list').on('click', '.respond-later', conversations.onRespondLaterClick);
  $('.list').on('click', '.archive', conversations.onArchiveClick);

  $("textarea[data-autosize]").autosize();

  $('.participants-expand-icon').click(function () {
    $('.participants-list', $(this).closest('.detail')).toggle();
    $(this).toggleClass('expanded');
  });
});
