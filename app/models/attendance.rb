class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :time, presence: true
end
