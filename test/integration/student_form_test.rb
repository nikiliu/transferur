require 'test_helper'

class StudentFormTest < ActionDispatch::IntegrationTest
  def setup
    @school1 = School.create!(name: "University of Richmond", location: "Richmond, VA", international: false)
    @school1.courses.create!(name: "Calculus I",  course_num: "MATH 211")
    @school1.courses.create!(name: "Calculus II", course_num: "MATH 212")

    @school2 = School.create!(name: "Bar University", location: "Bar", international: true)
    @school2.courses.create!(name: "Calculus I",  course_num: "MATH 101")
    @school2.courses.create!(name: "Calculus II", course_num: "Math 102")

    @transfer1 = TransferRequest.create!(transfer_school_id: @school2.id,
                                         transfer_course_id: @school2.courses.first.id,
                                         ur_course_id:       @school1.courses.first.id,
                                         approved:           true)

    @form_data = {
      name:            "John Doe",
      email:           "test@test.com",
      transfer_school: @school2.id,
      transfer_course: @school2.courses.first.id,
      online:          0,
      dual_enrollment: 0,
      course_number:   @school1.courses.first.id
    }
  end

  def teardown
    @transfer1.destroy!
    @school1.destroy!
    @school2.destroy!
  end

  test "successful transfer request" do
    post_via_redirect new_transfer_request_path, ActionController::Parameters.new(@form_data)
    assert !flash[:success].nil?
  end

  test "dual enrollment transfer request" do
    @form_data[:dual_enrollment] = 1
    post_via_redirect new_transfer_request_path, ActionController::Parameters.new(@form_data)
    assert !flash[:pending].nil?
  end

  test "missing name" do
    @form_data[:name] = ""
    post_via_redirect new_transfer_request_path, ActionController::Parameters.new(@form_data)
    assert !flash[:error].nil?
  end

  test "missing email" do
    @form_data[:email] = ""
    post_via_redirect new_transfer_request_path, ActionController::Parameters.new(@form_data)
    assert !flash[:error].nil?
  end

  test "invalid email" do
    @form_data[:email] = "foo"
    post_via_redirect new_transfer_request_path, ActionController::Parameters.new(@form_data)
    assert !flash[:error].nil?
  end
end
