require 'test_helper'

class TransferRequestTest < ActiveSupport::TestCase
  def setup
    @ur               = School.create!(name: "University of Richmond",
                                       location: "Richmond, VA",
                                       international: false)
    @ur_course        = @ur.courses.create!(name: "Foo", course_num: "Bar")
    @transfer_school  = School.create!(name: "Foo", location: "Bar", international: true)
    @transfer_course  = @transfer_school.courses.create!(name: "Foo", course_num: "Bar")
    @transfer_request = TransferRequest.new(transfer_school_id: @transfer_school.id,
                                            transfer_course_id: @transfer_course.id,
                                            ur_course_id:       @ur_course.id,
                                            approved:           true)
  end

  def teardown
    @ur.destroy!
    @transfer_school.destroy!
  end

  test "valid transfer request" do
    assert @transfer_request.valid?
  end

  test "unapproved without reason" do
    @transfer_request.approved = false
    assert !@transfer_request.valid?
  end
end
