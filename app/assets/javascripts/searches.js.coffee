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
    $('#radius_input').removeAttr('disabled').css("background","rgb(255, 227, 77)") 

  $('#radius_input').change ->
    if $(this).val() == ""
      $(this).css("background","rgb(255, 227, 77)") 
    else
      $(this).css("background","#fff") 

  $('#location_city').change ->
    if $(this).val() == ""
      $('#radius_input').attr('disabled', 'disabled').val("شعاع کیلومتری").css("background","#f7f7f7")  
    else
      if $('#radius_input').val() == ""
        $('#radius_input').removeAttr('disabled').css("background","rgb(255, 227, 77)")  
      else
        $('#radius_input').removeAttr('disabled').css("background","#fff")  
  ##########################

  ########################## remove_filter

  $('.filter select').change ->
    if $("option:selected", this).val() !=""
      $(this).addClass("smallwidth")
      $(this).parent().next().removeClass("myhide")
    else
      $(this).removeClass("smallwidth")
      $(this).parent().next().addClass("myhide")

  $(".remove_filter").click ->
    select = $(this).addClass("myhide").prev().children()
    select.val("").removeClass("smallwidth")