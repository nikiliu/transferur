class PendingRequest < ActiveRecord::Base
  validates :transfer_school_name,          presence: true
  validates :transfer_school_location,      presence: true
  validates :transfer_school_international, inclusion: { in: [true, false] }
  validates :transfer_course_name,          presence: true
  validates :transfer_course_num,           presence: true
  validates :ur_course_id,                  presence: true
end
