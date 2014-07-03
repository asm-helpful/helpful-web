$(function(){
  var $replyMessage = $('[data-reply-to-message]');

  var editor = new MediumEditor($replyMessage, {
    placeholder: $replyMessage.attr('placeholder'),
    cleanPastedHTML: true
  });

  setTimeout(function() { $replyMessage.focus() }, 0);

  $("form[data-reply-form]").submit(function( event ) {
    var content = $("[data-reply-to-message]").html()
    $(this).find("#message_content").val(content)
  });

});
