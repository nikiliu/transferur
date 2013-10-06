require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @school = School.create!(name: "Foo", location: "Bar", international: true)
    @course = @school.courses.new(name: "Foo", course_num: "Bar")
  end

  def teardown
    @school.destroy!
  end

  test "valid course" do
    assert @course.valid?
  end

  test "no name" do
    @course.name = ""
    assert !@course.valid?
  end

  test "no course num" do
    @course.course_num = ""
    assert !@course.valid?
  end
end
