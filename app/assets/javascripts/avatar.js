var toggleAvatar = function(img) {
  $(img).hide();
  $(img).siblings().show();
};

window.toggleAvatar = toggleAvatar;
