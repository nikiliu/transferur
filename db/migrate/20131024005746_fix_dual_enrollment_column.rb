class FixDualEnrollmentColumn < ActiveRecord::Migration
  def change
    remove_column :pending_requests, :dual_enrollment, :string
    add_column    :pending_requests, :dual_enrollment, :boolean
  end
end
