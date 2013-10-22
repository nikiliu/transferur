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
    success:  (data) -> $("#pending_request_transfer_course_id").html(data)

# Fires ajax function when a transfer school is selected
#------------------------------------------------------------------------
$("#pending_request_transfer_school_id").change(() ->
  update_transfer_courses($(this).val())
).change()

# Swap input for other transfer school
#------------------------------------------------------------------------
first_exec = true
$("#pending_request_transfer_school_other").change(() ->
  if $(this).is(":checked")
    $(".other-school").show()
    $("#pending_request_transfer_school_id").prop("disabled", true)
    $("#pending_request_transfer_course_other").prop("checked", true).change()
  else
    $(".other-school").hide()
    $("#pending_request_transfer_school_id").prop("disabled", false)
    if not first_exec
      $("#pending_request_transfer_course_other").prop("checked", false).change()
    else first_exec = false
).change()

# Swap input for other transfer course
#------------------------------------------------------------------------
$("#pending_request_transfer_course_other").change(() ->
  $(this).prop("checked", true) if $("#pending_request_transfer_school_other").is(":checked")
  if $(this).is(":checked")
    $("#pending_request_transfer_course_id").prop("disabled", true)
    $(".other-course").show()
  else
    $("#pending_request_transfer_course_id").prop("disabled", false)
    $(".other-course").hide()
).change()
