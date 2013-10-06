class TransferRequest < ActiveRecord::Base
  validates :transfer_school_id, presence: true
  validates :transfer_course_id, presence: true
  validates :ur_course_id,       presence: true
  validates :approved,           presence: true
  validates :reasons,            presence: true, unless: "approved == true"
end
