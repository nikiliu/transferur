class Course < ActiveRecord::Base
  belongs_to :school

  validates :name,       presence: true
  validates :course_num, presence: true

  # Returns the name of the course along with its course number
  def full_name
    "#{name} (#{course_num})"
  end
end
