class AddUrlToPendingRequests < ActiveRecord::Migration
  def change
    add_column :pending_requests, :url, :string
  end
end
