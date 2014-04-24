$(document).ready(function(){
  //style blurred search bar with value
  $('#search-query').focus(function(e){
    $(this).removeClass('filled');
  });

  $('#search-query').blur(function(e){
    if(this.value.length > 0){
      $(this).addClass('filled');
    } else
    {
      $(this).removeClass('filled');
    }
  });

  $('.search-bar-clear-icon').click(function(e)
  {
    e.preventDefault();
    $('#search-query').val('').blur();
  });
});
