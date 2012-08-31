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


/* jQuery selector to match exact text inside an element
*  :containsExact()     - case insensitive
*  :containsExactCase() - case sensitive
*  :containsRegex()     - set by user ( use: $(el).find(':containsRegex(/(red|blue|yellow)/gi)') )
*/
$.extend($.expr[':'],{
  containsRegexp: function(a,i,m){
    var regreg =  /^\/((?:\\\/|[^\/])+)\/([mig]{0,3})$/,
    reg = regreg.exec(m[3]);
    return reg ? RegExp(reg[1], reg[2]).test($.trim(a.innerHTML)) : false;
  }
});

$(function() {
  impress().init();
  
  $("#nav-home-btn").click(function() {
    impress().goto(0);
    event.preventDefault();
  });

  $("#nav-prev-btn").click(function() {
    impress().prev();
    event.preventDefault();
  });

  $("#nav-next-btn").click(function() {
    impress().next();
    event.preventDefault();
  });
  
  $("#nav-new-step").click(function() {
    alert($(this).attr("id"));
    event.preventDefault();
  });

  $("#nav-new-slide").click(function() {
    alert($(this).attr("id"));
    event.preventDefault();
  });

  $("#nav-create-duplicate").click(function() {
    alert($(this).attr("id"));
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
    if(/btn-primary/.test($(this).attr('class'))) {
      $(this).removeClass('btn-primary').addClass('btn-inverse');
      $(".step").attr('contenteditable', false);
    } else {
      $(this).addClass('btn-primary').removeClass('btn-inverse');
      $(".step").attr('contenteditable', true);
    }
    event.preventDefault();
  });
  
  $("#nav-search").submit(function() {
    var text = $("#nav-search input").val();
    var found = $('.step *:containsRegexp("/' + text + '/gi")');
    impress().goto($(found.first()).closest(".step").attr("id"));
    event.preventDefault();
  });
  
  $('#nav-search').typeahead({
    source: function (query, process) {
      return process(["a"]);
    }
  });
  
  $("#nav-start-presentation").click(function() {
    alert($(this).attr("id"));
    event.preventDefault();
  });
  
  $("#nav-download-presentation").click(function() {
    alert($(this).attr("id"));
    event.preventDefault();
  });
  
  // BEGIN:search
  var that = this;
  that.input = $("#nav-search input");

  // handles searching the document
  that.performSearch = function() {

    // create a search string
    var phrase = that.input.val().replace(/^\s+|\s+$/g, "");          
    phrase = phrase.replace(/\s+/g, "|");

    // remove all highlighters
    $(".highlight").each(function(i, v) {$(v).replaceWith($(v).text())});

    // make sure there are a couple letters
    if(phrase.length < 2) {
      return;
    }

    // append the rest of the expression
    phrase = ["\\b(", phrase, ")"].join("");

    // search for any matches
    var count = 0;
    $(".step h1, .step h2, .step p, .step q").each(function(i, v) {
      var block = $(v);
      block.html(
        block.html().replace(
          new RegExp(phrase, "gi"), 
          function(match) {
            count++;
            return ["<span class='highlight'>", match, "</span>"].join("");
          })
        );
      });

      // update the count
      // $(".result-count").text(count + " results on this page!");

      // clear this search attempt
      // should be gone anyways...
      that.search = null;
    };

    that.search;
    that.input.keyup(function(event) {
      if (that.search) { clearTimeout(that.search); }
      that.search = setTimeout(that.performSearch, 300);
    });

  });
  // END:search
  
Aloha.ready(function() {
  $ = Aloha.jQuery;
  $('.step').aloha();
});

