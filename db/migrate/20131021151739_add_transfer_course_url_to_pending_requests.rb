class AddTransferCourseUrlToPendingRequests < ActiveRecord::Migration
  def change
    add_column :pending_requests, :transfer_course_url, :string
  end
end
