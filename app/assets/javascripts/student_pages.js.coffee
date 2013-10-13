# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Updates the .transfer-course div with data retrieved via ajax from
# student_pages#update_transfer_courses.
update_transfer_courses = (school_id) ->
  $.ajax
    url:      "/update_transfer_courses"
    type:     "GET"
    data:     { "school_id": school_id }
    dataType: "html"
    success:  (data) ->
      $(".transfer-course").html(data)

# Fires ajax function when a transfer school is selected
$("#transfer_school").change () ->
  update_transfer_courses($(this).val())
