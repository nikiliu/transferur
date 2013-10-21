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
    success:  (data) -> $(".transfer-course").html(data)

# Fires ajax function when a transfer school is selected
#------------------------------------------------------------------------
$("#pending_request_transfer_school_id").change(() ->
  update_transfer_courses($(this).val())
).change()

# Swap input for other transfer school
#------------------------------------------------------------------------
$("#pending_request_transfer_school_other").change () ->
  if $(this).is(":checked")
    $("#pending_request_transfer_school_id").prop("disabled", true)
    $(".other-school").show()
    $("#pending_request_transfer_course_other").prop("checked", true)
                                               .prop("disabled", true)
                                               .change()
  else
    $("#pending_request_transfer_school_id").prop("disabled", false)
    $(".other-school").hide()
    $("#pending_request_transfer_course_other").prop("checked", false)
                                               .prop("disabled", false)
                                               .change()

# Swap input for other transfer course
#------------------------------------------------------------------------
$(".transfer-course").on "change", "#pending_request_transfer_course_other", () ->
  $(this).prop("checked", true) if $(this).is(":checked")
  if $(this).is(":checked")
    $("#pending_request_transfer_course_id").prop("disabled", true)
    $(".other-course").show()
  else
    $("#pending_request_transfer_course_id").prop("disabled", false)
    $(".other-course").hide()
