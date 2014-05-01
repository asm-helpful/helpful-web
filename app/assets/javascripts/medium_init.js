$(document).on("ready page:change", function(){
  var editor = new MediumEditor('[data-reply-to-message]', {
    placeholder: "Write Your Reply"
  });

  $("form[data-reply-form]").submit(function( event ) {
    var content = $("[data-reply-to-message]").html()
    $(this).find("#message_content").val(content)
  });

});
