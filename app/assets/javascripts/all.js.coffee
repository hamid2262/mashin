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

  ########## MAX 10 digits
  $(".limit11digit").keydown (e)->
    value = $(this).val()
    if value.length > 11 
      if !($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) != -1)
        e.preventDefault()

  ###########  add '/' to currency 
  $(".currencies").click ->
    $(this).select()
    value = $(this).val()
    value = value.replace(/[^0-9]+/g, "");  
    $(this).val( value.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1/") ); 

  $(".currencies").keyup ->
    value = $(this).val()
    value = value.replace(/[^0-9]+/g, "");  
    $(this).val( value.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1/") ); 

  ###########  remove non-number chars from phones
  $(".phones").keyup ->
    value = $(this).val()
    value = value.replace(/([^0-9 \- ,_+()])/g, "");  
    $(this).val( value ); 


