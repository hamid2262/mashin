jQuery ->
  ######################### provide car models for select option
  car_models = $('#car_model_id').html()
  make = $("option:selected", "#make_id").text()
  escaped_car_models = make.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
  options = $(car_models).filter("optgroup[label='#{escaped_car_models}']").html()
  options = ["<option value=\"\"></option>"]+options 
  $('#car_model_id').html(options)
  $('#make_id').change ->
    $('#car_model_id').html('')
    make = $("option:selected", this).text()
    escaped_car_models = make.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(car_models).filter("optgroup[label='#{escaped_car_models}']").html()
    options = ["<option value=\"\"></option>"]+options 
    $('#car_model_id').html(options)
  #########################

  ######################### changing radius color while location typing
  $('#radius_input').attr('disabled', 'disabled') if $('#location_city').val() == "" 
  $('#radius_input').removeAttr('disabled') if $('#location_city').val() != "" 
  if $('#location_city').val() != "" and $('#radius_input').val() == ""
    $('#radius_input').removeAttr('disabled').addClass('hint_red_shadow') 

  $('#radius_input').change ->
    if $(this).val() == ""
      $(this).addClass('hint_red_shadow') 
    else
      $(this).removeClass('hint_red_shadow')  

  $('#location_city').change ->
    if $(this).val() == ""
      $('#radius_input').attr('disabled', 'disabled').val("شعاع کیلومتری").css("background","#f7f7f7")  
    else
      if $('#radius_input').val() == ""
        $('#radius_input').removeAttr('disabled').addClass('hint_red_shadow') 
      else
        $('#radius_input').removeAttr('disabled').removeClass('hint_red_shadow') 
  ##########################

  ########################## remove_filter

  $('.filter select').change ->
    if $("option:selected", this).val() !=""
      $(this).addClass("with_value")
      $(this).parent().next().removeClass("myhide")
    else
      $(this).removeClass("with_value")
      $(this).parent().next().addClass("myhide")

  $(".remove_filter").click ->
    select = $(this).addClass("myhide").prev().children()
    select.val("").removeClass("with_value")
    $("#main_search_form").submit()

#-------------------------
  $(".filter input[type='text']").keyup ->
    if $(this).val() !=""
      $(this).addClass("with_value")
      $(this).parent().next().removeClass("myhide")
    else
      $(this).removeClass("with_value")
      $(this).parent().next().addClass("myhide")

#############################  filter_sections_badge_link   
  $(".filter_sections_badge_link").click (event)->
    event.preventDefault()
    $("form",this ).submit()

#############################  filter_sections_see_more   
  $(".filter_sections .myhidden").hide();
  $(".filter_sections a.show_more").click (event)->
    event.preventDefault()
    $(this).prev().children(".myhidden").slideToggle()
    $(this).prev().children().toggleClass("smallHeght")
