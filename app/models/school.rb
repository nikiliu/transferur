class School < ActiveRecord::Base
  has_many :courses, dependent: :destroy

  validates :name,          presence: true
  validates :location,      presence: true
  validates :international, inclusion: { in: [true, false] }
end
