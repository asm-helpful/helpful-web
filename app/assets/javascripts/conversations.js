var conversations = {
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

$(function() {
  $('.list').on('click', '.archive', conversations.onArchiveClick);

  $("textarea[data-autosize]").autosize();

  $('.participants-expand-icon').click(function () {
    $('.participants-list', $(this).closest('.detail')).toggle();
    $(this).toggleClass('expanded');
  });
});
