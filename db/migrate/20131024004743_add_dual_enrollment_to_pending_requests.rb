class AddDualEnrollmentToPendingRequests < ActiveRecord::Migration
  def change
    add_column :pending_requests, :dual_enrollment, :string
  end
end
