$ ->
  # in ad show for showing big pics on hover
  $("#ad_show #thumbs .thumb").hover ->
    $(this).parent().children().removeClass("my_active")
    $(this).addClass("my_active")
    $("#big_images .big_image").hide()
    index = $("#ad_show #thumbs .thumb").index(this)
    $("#big_images .big_image:nth-child("+(index+1)+")").show()

  # in ad new toggle miladi and shamsi
  format = $("#ad_form #year_format input[checked='checked']").val() 
  if format == "true"
    $("#ad_form .year_miladi").hide()
  else if format == "false"
    $("#ad_form .year_shamsi").hide()

  $("#ad_form #year_format input").change ->
    if $(this).val() == "false"
      $("#ad_form .year_miladi").show()
      $("#ad_form .year_shamsi").hide()
      # $("#ad_form .year_shamsi select").prop('selectedIndex',0);
    else
      $("#ad_form .year_shamsi").show()
      $("#ad_form .year_miladi").hide()
      # $("#ad_form .year_miladi select").prop('selectedIndex',0);

  #### usage type radio buttom change
  $("#ad_form input:radio[name='ad[usage_type]']").click ->
    ad_millage = $("#ad_millage")
    if $(this).val() != "0"
      $("#ad_millage").val('').attr('disabled','disabled')
    else
      $("#ad_millage").removeAttr('disabled')

# hover on big image
  imagePreview()
  $("a.preview").click (event) ->
    event.preventDefault()
    return
  return

@imagePreview = ->
  xOffset = 1000
  yOffset = 10
  width = (if (window.innerWidth > 0) then window.innerWidth else screen.width)
  $("a.preview").hover ((e) ->
    $("body").append "<p id='preview'><img src='" + @href + "' alt='Image preview' /></p>"
    $("#preview").css("top", (e.pageY * -5 + xOffset) + "px").css("right", (width - e.pageX + yOffset) + "px").fadeIn "fast"
    return
  ), ->
    @title = @t
    $("#preview").remove()
    return

  $("a.preview").mousemove (e) ->
    # $("#preview").css("top", (e.pageY * -5 + xOffset) + "px").css "right", (width - e.pageX + yOffset) + "px"
    top = $("#big_images").offset().top - 20
    right = $( window ).width() - $("#big_images").offset().left + 20
    $("#preview").css("top", (top) + "px").css "right", (right) + "px"
    return

  return