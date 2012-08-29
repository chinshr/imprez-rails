// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require impress
//= require twitter/bootstrap

$(function() {
  impress().init();
  
  $("#nav-home-btn").click(function() {
    impress().goto(0);
  });

  $("#nav-prev-btn").click(function() {
    impress().prev();
  });

  $("#nav-next-btn").click(function() {
    impress().next();
  });
  
  $("#nav-new-step").click(function() {
    alert("New Step");
    event.preventDefault();
  });

  $("#nav-new-slide").click(function() {
    alert("New Slide");
    event.preventDefault();
  });

  $("#nav-create-duplicate").click(function() {
    alert("Duplicate current");
    event.preventDefault();
  });

  $("#nav-remove-current").click(function(event) {
    if(confirm("Do you really want to remove the current step?")) {
      $(impress().currentStep()).remove();
      impress().reset();
    }
    event.preventDefault();
  });

  $("#nav-edit-btn").click(function() {
    var el = $(this);
    if(/btn-primary/.test(el.attr('class'))) {
      el.removeClass('btn-primary').addClass('btn-inverse');
    } else {
      el.addClass('btn-primary').removeClass('btn-inverse');
    }
    event.preventDefault();
  });
  
});

Aloha.ready(function() {
  $ = Aloha.jQuery;
  $('.step').aloha();
});

