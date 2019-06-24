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

  def to_single_lesson
    single_lesson = SingleLesson.new
    single_lesson.start_date_time = self.start_datetime + (week_day - Date.today.wday).day
    single_lesson.end_date_time = self.end_datetime + (week_day - Date.today.wday).day
    single_lesson.group_id = group_id
    single_lesson.id = self.id
    return single_lesson
  end

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
