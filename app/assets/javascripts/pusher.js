$(function(){
  Pusher.log = function(message) {
    if (window.console && window.console.log) {
      window.console.log(message);
    }
  };

  if($(".list").length){
    var pusher = new Pusher($(".list").data("pusher-key"));
    var listUrl = $(".list").data("url");
    var channel = pusher.subscribe($(".list").data("pusher-channel"));

    channel.bind('new_message', function(data) {
      $(".list").load(listUrl);
    });

    $(".list").load(listUrl);
  }
});
