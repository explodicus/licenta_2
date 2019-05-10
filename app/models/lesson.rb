class Lesson < ApplicationRecord
  belongs_to :group
  validates :week_day, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_after_start

  def start_datetime
    Time.new(Time.now.year, Time.now.month, Time.now.day, start_time.hour,
             start_time.min)
  end

  def end_datetime
    Time.new(Time.now.year, Time.now.month, Time.now.day, end_time.hour,
             end_time.min)
  end

  def attendances
    Attendance.where('time > ? AND time < ?', start_datetime, end_datetime)
  end

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
