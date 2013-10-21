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
    $("#transfer_school").prop("disabled", true)
    $(".other-school").show()
    $("#other_course_check").prop("checked", true)
                            .prop("disabled", true)
                            .change()
  else
    $("#transfer_school").prop("disabled", false)
    $(".other-school").hide()
    $("#other_course_check").prop("checked", false)
                            .prop("disabled", false)
                            .change()

# Swap input for other transfer course
#------------------------------------------------------------------------
$(".transfer-course").on "change", "#other_course_check", () ->
  $(this).prop("checked", true) if $("#other_school_check").is(":checked")
  if $(this).is(":checked")
    $("#transfer_course").prop("disabled", true)
    $(".other-course").show()
  else
    $("#transfer_course").prop("disabled", false)
    $(".other-course").hide()
