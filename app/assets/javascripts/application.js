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
//= require jquery.turbolinks
//= require jquery.validate
//= require localization/messages_fa
//= require jquery_ujs
//= require jquery.ui.slider

//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

//= require bootstrap.min
//= require underscore-min
//= require gmaps/google

//= require_tree .
//= require turbolinks

  // jQuery.fn.submitOnChange(){
  //   $('#ajax_submit').trigger("click");
  // }

$(function() {

////////////// AJAX mainsearch
  $('#main_search_form #location_city').focusout(function () {
    field_name = $(this).attr("name")
    field_name = field_name.replace("search[",'')
    field_name = field_name.replace("]",'')

    field_value = $(this).val()

    $("#filter_name_ajax").val(field_name)
    $("#filter_value_ajax").val(field_value)
    $('#ajax_submit').submit();
  })

  $('#main_search_form select').change(function () {
    field_name = $(this).attr("name")
    field_name = field_name.replace("search[",'')
    field_name = field_name.replace("]",'')

    field_value = $(this).val()

    $("#filter_name_ajax").val(field_name)
    $("#filter_value_ajax").val(field_value)
    $('#ajax_submit').submit();
  })
//////////////////\\\\\\\\\\\\\\\


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
});