//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap

$(document).ready(function() { 
  var $winwidth  = $(window).width();
  $("img.source-image").attr({
    width: $winwidth
  });
  $(window).bind("resize", function(){ 
    var $winwidth = $(window).width();
    $("img.source-image").attr({
      width: $winwidth
    });
  });
});

$("img.source-image").load(function() {
  // the image is loaded now
});