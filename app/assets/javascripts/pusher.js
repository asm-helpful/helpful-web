$(function(){
  // Pusher global vars
  var pusher = new Pusher($(".list").data("pusher-key"));
  var listUrl = $(".list").data("url");
  var channel = pusher.subscribe($(".list").data("pusher-channel"));

  // Pusher logger
  Pusher.log = function(message) {
    if (window.console && window.console.log) {
      window.console.log(message);
    }
  };

  // Pusher event bind
  if($(".list").length){
    channel.bind('new_message', function(data) { loadList(); });
    loadList();
  }

  // Ajax load list function
  function loadList(){
    $(".list").load(listUrl, function(){
      if($(".list .list-item").length == 0){
        $(".panel.empty-state").show();
      } else {
        $(".panel.empty-state").hide();
      }
    });
  }
});
