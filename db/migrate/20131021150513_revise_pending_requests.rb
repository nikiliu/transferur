class RevisePendingRequests < ActiveRecord::Migration
  def change
    remove_column :pending_requests, :url,                   :string

    add_column    :pending_requests, :requester_name,        :string
    add_column    :pending_requests, :requester_email,       :string

    add_column    :pending_requests, :transfer_school_id,    :integer
    add_column    :pending_requests, :transfer_school_other, :boolean

    add_column    :pending_requests, :transfer_course_id,    :integer
    add_column    :pending_requests, :transfer_course_other, :boolean
  end
end
