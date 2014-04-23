$(document).ready(function(){
  //style blurred search bar with value
  $('#search-query').blur(function(e){
    if(this.value.length > 0){
      $(this).addClass('filled');
    } else
    {
      $(this).removeClass('filled');
    }
  });
});
