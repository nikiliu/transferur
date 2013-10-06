class Course < ActiveRecord::Base
  belongs_to :school

  validates :name,       presence: true
  validates :course_num, presence: true
end
