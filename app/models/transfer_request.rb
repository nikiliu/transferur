class TransferRequest < ActiveRecord::Base
  validates :transfer_school_id, presence: true
  validates :transfer_course_id, presence: true
  validates :ur_course_id,       presence: true
  validates :approved,           inclusion: { in: [true, false] }
  validates :reasons,            presence: true, unless: "approved == true"

  # Returns transfer school
  def transfer_school
    School.find_by(id: transfer_school_id)
  end

  # Returns transfer course
  def transfer_course
    transfer_school.courses.find_by(id: transfer_course_id)
  end

  # Returns UR course
  def ur_course
    School.first.courses.find_by(id: ur_course_id)
  end
end
