module PendingRequestsHelper
  def pending_request_display(request)
    transfer_school = { name:       request.transfer_school_name }
    transfer_course = { course_num: request.transfer_course_num }
    ur_course       = School.first.courses.find_by(id: request.ur_course_id)

    if not request.transfer_school_other
      transfer_school = School.find_by(id: request.transfer_school_id)
    end

    if not request.transfer_course_other
      transfer_course = transfer_school.courses.find_by(id: request.transfer_course_id)
    end

    "#{transfer_school.name} #{transfer_course.course_num} => UR #{ur_course.course_num}"
  end
end
