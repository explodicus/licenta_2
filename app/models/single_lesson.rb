class SingleLesson < ApplicationRecord
  belongs_to :group
  validates :start_date_time, presence: true
  validates :end_date_time, presence: true
  validate :end_after_start

  def old_start_time
    Time.new(2000, 1, 1, start_date_time.hour, start_date_time.min) + 1.minute
  end

  def old_end_time
    Time.new(2000, 1, 1, end_date_time.hour, end_date_time.min) - 1.minute
  end

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?

    if end_date_time < start_date_time
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
