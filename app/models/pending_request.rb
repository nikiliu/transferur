class PendingRequest < ActiveRecord::Base

  # Validate requester
  validates :requester_name,  presence: true
  validates :requester_email, presence: true, format: { with: /@/ }

  # Validate transfer school
  validates :transfer_school_id,            presence: true, numericality: { greater_than: 0, message: "not selected" }, unless: :transfer_school_other?
  validates :transfer_school_other,         inclusion: { in: [true, false] }
  validates :transfer_school_name,          presence: true,                   if: :transfer_school_other?
  validates :transfer_school_location,      presence: true,                   if: :transfer_school_other?
  validates :transfer_school_international, inclusion: { in: [true, false] }, if: :transfer_school_other?

  # Validate transfer course
  validates :transfer_course_id,    presence: true, numericality: { greater_than: 0, message: "not selected" }, unless: :transfer_course_other?
  validates :transfer_course_other, inclusion: { in: [true, false] }
  validates :transfer_course_name,  presence: true, if: :transfer_course_other?
  validates :transfer_course_num,   presence: true, if: :transfer_course_other?
  validates :transfer_course_url,   presence: true

  # Validate dual enrollment
  validates :dual_enrollment, inclusion: { in: [true, false] }

  # Validate UR course
  validates :ur_course_id, presence: true, numericality: { greater_than: 0, message: "not selected" }

  # Returns School based on transfer_school_id
  def transfer_school
    School.find_by(id: transfer_school_id)
  end

  # Returns Course based on transfer_school_id and transfer_course_id
  def transfer_course
    transfer_school.courses.find_by(id: transfer_course_id)
  end

  # Returns UR course
  def ur_course
    School.first.courses.find_by(id: ur_course_id)
  end

  # Returns whether the transfer_school_other field is true
  def transfer_school_other?
    transfer_school_other == true
  end

  # Returns whether the transfer_course_other field is true
  def transfer_course_other?
    transfer_course_other == true
  end
end
