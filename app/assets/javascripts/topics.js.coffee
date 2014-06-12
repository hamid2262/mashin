jQuery ->
################### others_topics_home_see_more
  $("#others_topics_home .myhidden").addClass("hover_hidden");
  $(".topic_list").hover ->
    $(this).find(".myhidden").removeClass("hover_hidden")
  $(".topic_list").mouseleave ->
    $(this).find(".myhidden").addClass("hover_hidden")