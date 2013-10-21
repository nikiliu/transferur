class PendingRequest < ActiveRecord::Base
  validates :transfer_school_id,            presence: true,                   unless: :transfer_school_other?
  validates :transfer_school_other,         inclusion: { in: [true, false] }
  validates :transfer_school_name,          presence: true,                   if: :transfer_school_other?
  validates :transfer_school_location,      presence: true,                   if: :transfer_school_other?
  validates :transfer_school_international, inclusion: { in: [true, false] }, if: :transfer_school_other?

  validates :transfer_course_id,    presence: true, unless: :transfer_course_other?
  validates :transfer_course_other, inclusion: { in: [true, false] }
  validates :transfer_course_name,  presence: true, if: :transfer_course_other?
  validates :transfer_course_num,   presence: true, if: :transfer_course_other?
  validates :transfer_course_url,   presence: true, if: :transfer_course_other?

  validates :ur_course_id, presence: true

  # Returns whether the transfer_school_other field is true
  def transfer_school_other?
    transfer_school_other == true
  end

  # Returns whether the transfer_course_other field is true
  def transfer_course_other?
    transfer_course_other == true
  end
end
