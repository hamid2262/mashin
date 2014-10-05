// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// require jquery.turbolinks
//= require jquery.validate
//= require localization/messages_fa
//= require jquery_ujs

//= require bootstrap-sprockets

// require twitter/bootstrap
//= require jquery-ui/slider

//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

//= require bootstrap.min
// require underscore-min
//= require gmaps/google

//= require_tree .
// require turbolinks


$(function() {

  // update url by tab changing
  $('.nav-tabs a').click(function (e) {
    $(this).tab('show');
    var scrollmem = $('body').scrollTop();
    window.location.hash = this.hash;
    // $('html,body').scrollTop(scrollmem);
  });

  // url change with nav-tabs hashed address
  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');

  // in user update profile when form has validation error, must go to tab that has error
  var t = $('p.tab').text();
  t = $('ul.nav a[href="#' + $.trim(t) + '"]');
  t && t.tab('show'); 

  $('.tooltip_bottom').tooltip();

  $(".validate-form").validate();



  // Enabling Ad Popover on search page
  $(".popoverData").popover({
      html : true, 
      container: 'body',
      placement : "bottom",
      trigger : "hover",
      delay: { "hide": 5 },
      content: function() {
        id = $(this).data('id');
        return $('#Content-'+id).html();
      },
      title: function() {
        id = $(this).data('id');
        return $('#Title-'+id).html();
      }
  });



  imagePreview();
  $("a.preview").click(function (event) {
    event.preventDefault();
  });

});



this.imagePreview = function(){ 
  xOffset = 1000;
  yOffset = 10;
  width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
  $("a.preview").hover(function(e){
    $("body").append("<p id='preview'><img src='"+ this.href +"' alt='Image preview' /></p>");  
    $("#preview")
      .css("top",(e.pageY*-5  + xOffset) + "px")
      .css("right",(width - e.pageX + yOffset) + "px")
      .fadeIn("fast");            
    },
  function(){
    this.title = this.t;  
    $("#preview").remove();
    }); 
  $("a.preview").mousemove(function(e){
    $("#preview")
      .css("top",(e.pageY*-5 + xOffset) + "px")
      .css("right",(width - e.pageX + yOffset) + "px");
  });     
};