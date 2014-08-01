$(function() {
  if($('#canned-div').length) {
    var messagePlaceholder = $('.editable').attr("data-placeholder");
    var editor = new MediumEditor('.editable', { placeholder: messagePlaceholder });

    $('#canned-div').html($('#canned-field').val());

    $('#submit-can-response').click(function() {
      $('#canned-field').val($('#canned-div').html());
    });
  }
});
