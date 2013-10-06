class AddMultiColumnUniqueness < ActiveRecord::Migration
  def change
    add_index :courses, [:school_id, :name, :course_num],   unique: true
    add_index :schools, [:name, :location, :international], unique: true
    add_index :transfer_requests, [:transfer_school_id,
                                   :transfer_course_id,
                                   :ur_course_id],          unique: true, name: "unique_transfers"
  end
end
