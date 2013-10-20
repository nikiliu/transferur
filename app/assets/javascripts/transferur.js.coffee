#========================================================================
# transferur.js.coffee
#========================================================================

# Updates the .transfer-course div with data retrieved via ajax from
# student_pages#update_transfer_courses.
#------------------------------------------------------------------------
update_transfer_courses = (school_id) ->
  $.ajax
    url:      "/update_transfer_courses"
    type:     "GET"
    data:     { "school_id": school_id }
    dataType: "html"
    success:  (data) ->
      $(".transfer-course").html(data)

# Fires ajax function when a transfer school is selected
#------------------------------------------------------------------------
$("#transfer_school").change(() ->
  update_transfer_courses($(this).val())
).change()

# Swap input for other transfer school
#------------------------------------------------------------------------
$("#other_school_check").change () ->
  if $(this).is(":checked")
    $(".transfer-school").hide()
    $(".other-school").show()
  else
    $(".transfer-school").show()
    $(".other-school").hide()

# Swap input for other transfer course
#------------------------------------------------------------------------
$(".transfer-course").on "change", "#other_course_check", () ->
  if $(this).is(":checked")
    $(".transfer-course-select").hide()
    $(".other-course").show()
  else
    $(".transfer-course-select").show()
    $(".other-course").hide()
