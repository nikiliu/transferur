class CreatePendingRequests < ActiveRecord::Migration
  def change
    create_table :pending_requests do |t|
      t.string :transfer_school_name
      t.string :transfer_school_location
      t.boolean :transfer_school_international
      t.string :transfer_course_name
      t.string :transfer_course_num
      t.integer :ur_course_id

      t.timestamps
    end
  end
end
