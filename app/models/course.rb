class Course < ActiveRecord::Base
  belongs_to :school

  validates :name,       presence: true
  validates :course_num, presence: true

  # Returns the name of the course along with its course number
  def full_name
    "#{name} (#{course_num})"
  end

  # Returns all transfer requests with this course
  def transfer_requests
    TransferRequest.where(transfer_school_id: school_id, transfer_course_id: id)
  end
end
