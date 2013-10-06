class CreateTransferRequests < ActiveRecord::Migration
  def change
    create_table :transfer_requests do |t|
      t.integer :transfer_school_id
      t.integer :transfer_course_id
      t.integer :ur_course_id
      t.boolean :approved
      t.string :reasons

      t.timestamps
    end
  end
end
