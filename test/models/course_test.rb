require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @school = School.create!(name: "Foo", location: "Bar", international: true)
    @course = @school.courses.new(name: "Foo", course_num: "Bar")
  end

  def teardown
    @school.destroy!
  end

  test "correct schema" do
    assert @course.respond_to? :school_id
    assert @course.respond_to? :name
    assert @course.respond_to? :course_num
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

  test "duplicate course" do
    @course.save!
    dup_course = @course.dup
    assert_raises(ActiveRecord::RecordNotUnique) { dup_course.save }
  end

  test "same course at different school" do
    @course.save!
    diff_school = School.create!(name: "Bar", location: "Foo", international: false)
    same_course = diff_school.courses.new(name: "Foo", course_num: "Bar")
    assert same_course.save
    diff_school.destroy!
  end
end
