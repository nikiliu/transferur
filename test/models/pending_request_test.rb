require 'test_helper'

class PendingRequestTest < ActiveSupport::TestCase
  def setup
    @pending_request = PendingRequest.new(transfer_school_name: "Foo",
                                          transfer_school_location: "Bar",
                                          transfer_school_international: false,
                                          transfer_course_name: "Foo",
                                          transfer_course_num: "Bar",
                                          ur_course_id: 1,
                                          url: "http://example.com/")
  end

  def teardown
    @pending_request.destroy!
  end

  test "correct schema" do
    assert @pending_request.respond_to? :transfer_school_name
    assert @pending_request.respond_to? :transfer_school_location
    assert @pending_request.respond_to? :transfer_school_international
    assert @pending_request.respond_to? :transfer_course_name
    assert @pending_request.respond_to? :transfer_course_num
    assert @pending_request.respond_to? :ur_course_id
    assert @pending_request.respond_to? :url
  end

  test "valid pending request" do
    assert @pending_request.valid?
  end

  test "no transfer school name" do
    @pending_request.transfer_school_name = ""
    assert !@pending_request.valid?
  end

  test "no transfer school location" do
    @pending_request.transfer_school_location = ""
    assert !@pending_request.valid?
  end

  test "no transfer course name" do
    @pending_request.transfer_course_name = ""
    assert !@pending_request.valid?
  end

  test "no transfer course num" do
    @pending_request.transfer_course_num = ""
    assert !@pending_request.valid?
  end
end
