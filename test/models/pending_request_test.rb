require 'test_helper'

class PendingRequestTest < ActiveSupport::TestCase
  def setup
    @pending_request_1 = PendingRequest.new(
      requester_name: "Foo",
      requester_email: "foo@bar.com",
      transfer_school_id: 1,
      transfer_course_id: 1,
      transfer_school_other: false,
      transfer_course_other: false,
      transfer_course_url: "http://foo.com/",
      dual_enrollment: false,
      ur_course_id: 1
    )
    @pending_request_2 = PendingRequest.new(
      requester_name: "Foo",
      requester_email: "foo@bar.com",
      transfer_school_id: 1,
      transfer_school_other: false,
      transfer_course_other: true,
      transfer_course_name: "Foo Class",
      transfer_course_num: "Foo 101",
      transfer_course_url: "http://foo.com/",
      dual_enrollment: false,
      ur_course_id: 1
    )
    @pending_request_3 = PendingRequest.new(
      requester_name: "Foo",
      requester_email: "foo@bar.com",
      transfer_school_other: true,
      transfer_school_name: "Bar University",
      transfer_school_location: "Bar Town",
      transfer_school_international: false,
      transfer_course_other: true,
      transfer_course_name: "Foo Class",
      transfer_course_num: "Foo 101",
      transfer_course_url: "http://foo.com/",
      dual_enrollment: false,
      ur_course_id: 1
    )
  end

  def teardown
    @pending_request_1.destroy!
    @pending_request_2.destroy!
    @pending_request_3.destroy!
  end

  test "correct schema" do
    assert @pending_request_1.respond_to? :transfer_school_id
    assert @pending_request_1.respond_to? :transfer_school_other
    assert @pending_request_1.respond_to? :transfer_school_name
    assert @pending_request_1.respond_to? :transfer_school_location
    assert @pending_request_1.respond_to? :transfer_school_international

    assert @pending_request_1.respond_to? :transfer_course_id
    assert @pending_request_1.respond_to? :transfer_course_other
    assert @pending_request_1.respond_to? :transfer_course_name
    assert @pending_request_1.respond_to? :transfer_course_num
    assert @pending_request_1.respond_to? :transfer_course_url

    assert @pending_request_1.respond_to? :ur_course_id
  end

  test "valid pending request without other school or course" do
    assert @pending_request_1.valid?
  end

  test "valid pending request with other course" do
    assert @pending_request_2.valid?
  end

  test "valid pending request with other school" do
    assert @pending_request_3.valid?
  end

  test "missing requester name" do
    @pending_request_1.requester_name = ""
    assert !@pending_request_1.valid?
  end

  test "missing requester email" do
    @pending_request_1.requester_email = ""
    assert !@pending_request_1.valid?
  end

  test "invalid requester email" do
    @pending_request_1.requester_email = "foo"
    assert !@pending_request_1.valid?
  end

  test "missing transfer school name" do
    @pending_request_3.transfer_school_name = ""
    assert !@pending_request_3.valid?
  end

  test "missing transfer school location" do
    @pending_request_3.transfer_school_location = ""
    assert !@pending_request_3.valid?
  end

  test "missing transfer course name" do
    @pending_request_2.transfer_course_name = ""
    assert !@pending_request_2.valid?
  end

  test "missing transfer course num" do
    @pending_request_2.transfer_course_num = ""
    assert !@pending_request_2.valid?
  end

  test "missing transfer course url" do
    @pending_request_2.transfer_course_url = ""
    assert !@pending_request_2.valid?
  end

  test "unselected school" do
    @pending_request_1.transfer_school_id = "-1"
    assert !@pending_request_1.valid?
  end

  test "unselected course" do
    @pending_request_1.transfer_course_id = "-1"
    assert !@pending_request_1.valid?
  end

  test "unselected UR course" do
    @pending_request_1.ur_course_id = "-1"
    assert !@pending_request_1.valid?
  end
end
