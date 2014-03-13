$(document).ready(function() {
  $('.respond-later').click(function() {
    var $listItem = $(this).parents('.conversation-row').parent();
    var path = $(this).attr('data-account-conversation-path');

    var pushToEndOfQueue = function() {
      var $list = $listItem.parent();
      $listItem.remove().appendTo($list);
    }

    $.post(path, { conversation: { respond_later: true }, _method: 'patch' }, pushToEndOfQueue);

    return false;
  });
});
