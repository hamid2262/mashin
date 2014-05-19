$ ->
  #####################  restriction for selects with FROM - TO
  select_froms = $(".select_from")
  select_froms.each ->
    if $(this).val() != ""
      select_to = $(this).parent().parent().next().find(".select_to")

      current = $(this).val()
      select_to.find('option',this).each ( index ) ->
        if parseFloat($(this).val()) < parseFloat( current )
          $(this).remove()


  $(".select_from").change ->
    select_to = $(this).parent().parent().next().find(".select_to")
    select_to.html($(this).html())

    current = $(this).val()
    select_to.find('option',this).each ( index ) ->
      if parseFloat($(this).val()) < parseFloat( current )
        $(this).remove()
  #####################