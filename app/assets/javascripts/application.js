// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require rails-ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap
//= require_tree .


$(document).on('turbolinks:load', function(){
  $(".controls").css('visibility', 'hidden');
  $(".controls").css("display", "inline-block");
  $(".nav-links").css('color', 'ghostwhite');
  $(".nav-links").hover(function(){ // Mouse over
    $(this).css('color', '#428bca');
    $(this).stop().fadeTo(1000, 0.9);
    $(this).stop().fadeTo(1000, 0.8);
  }, function(){ // Mouse out
    $(this).css('color', 'ghostwhite');
    $(this).stop().fadeTo(1000, 1);
    $(this).stop().fadeTo(1000, 1);
  });
  $("a > span").hover(function(){
    $(this).css('color', 'lightgreen');
  }, function(){
    $(this).css('color', '#ffffff');
  });
});
