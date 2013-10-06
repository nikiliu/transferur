require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def setup
    @school = School.new(name: "Foo", location: "Bar", international: false)
  end

  test "valid school" do
    assert @school.valid?
  end

  test "no name" do
    @school.name = ""
    assert !@school.valid?
  end

  test "no location" do
    @school.location = ""
    assert !@school.valid?
  end

  test "no international" do
    @school.international = nil
    assert !@school.valid?
  end
end
