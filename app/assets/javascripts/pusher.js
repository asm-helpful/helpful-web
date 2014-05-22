function pusherStart() {
  // Pusher global vars
  var list = $(".list");
  var pusher = new Pusher($("meta[name='pusher-key']").attr("content"));
  var listUrl = list.data("url");
  var listChannel = list.data("pusher-channel");

  if (typeof listChannel == "undefined") {
    return;
  }

  var channel = pusher.subscribe(listChannel);

  // Pusher event bind
  if(list.length){
    channel.bind('new_message', function(data) {
        loadList();
    });
    loadList();
  }

  // Ajax load list function
  function loadList(){
    $(".list").load(listUrl, function(){
      if($(".list .list-item").length == 0){
        $(".conversation-row-empty").show();
      } else {
        $(".conversation-row-empty").hide();
      }
    });
  }
}

$(document).on("ready page:change", function(){
  pusherStart();
});
