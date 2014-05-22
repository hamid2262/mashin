$ ->
  # in ad show for showing big pics on hover
  $("#ad_show #thumbs .thumb").hover ->
    $(this).parent().children().removeClass("my_active")
    $(this).addClass("my_active")
    $("#big_images .big_image").hide()
    index = $("#ad_show #thumbs .thumb").index(this)
    $("#big_images .big_image:nth-child("+(index+1)+")").show()

  # in ad new toggle miladi and shamsi
  $("#ad_new .year_miladi").hide()
  $("#ad_new #year_format input").change ->
    if $(this).val() == "false"
      $("#ad_new .year_miladi").show()
      $("#ad_new .year_shamsi").hide()
      $("#ad_new .year_shamsi select").prop('selectedIndex',0);
    else
      $("#ad_new .year_shamsi").show()
      $("#ad_new .year_miladi").hide()
      $("#ad_new .year_miladi select").prop('selectedIndex',0);

  #### usage type radio buttom change
  $("#ad_new input:radio[name='ad[usage_type]']").click ->
    ad_millage = $("#ad_millage")
    if $(this).val() != "0"
      $("#ad_millage").val('').attr('disabled','disabled')
    else
      $("#ad_millage").removeAttr('disabled')

