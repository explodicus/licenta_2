class Group < ApplicationRecord
  has_many :relationships, dependent: :destroy
  has_many :users, through: :relationships
  has_many :lessons, dependent: :destroy
  has_many :single_lessons, dependent: :destroy
  has_many :attendances, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :kind, presence: true,
                   inclusion: { in: %w[Weekend Vacation International Academic] }
  before_save :default_values

  def all_lessons_week
    lessons = Array.new
    self.single_lessons.where('start_date_time > ? AND start_date_time < ?', Date.parse('Sunday').to_time, (Date.parse('Sunday') + 7.day).to_time).each do |lesson|
      lessons.append lesson
    end
    self.lessons.all.each do |lesson|
      lessons.append lesson.to_single_lesson
    end
    lessons.sort_by { |lesson| lesson.start_date_time }
  end

  def all_lessons_day(date)
    lessons = Array.new
    self.single_lessons.where('start_date_time > ? AND start_date_time < ?', date.to_time, (date + 1.day).to_time).each do |lesson|
      lessons.append lesson
    end
    self.lessons.all.each do |lesson|
      single_lesson = lesson.to_single_lesson
      if single_lesson.start_date_time.to_date == date
        lessons.append single_lesson
      end
    end
    lessons.sort_by { |lesson| lesson.start_date_time }
  end


  def find_lesson(lesson_time)
    self.all_lessons_day(lesson_time.to_date).each do |lesson|
      if lesson.start_date_time < lesson_time && lesson.end_date_time > lesson_time
        return lesson
      end
    end
    return false
  end

  def self.update_status
    Group.where(active: true).each do |group|
      if group.expiration_date == Date.today
        group.update_attributes active: false
      end
      if Vacation.where('start_date >= ? AND end_date <= ? AND kind = ?', Date.today, Date.today, group.kind).count > 0
        unless group.in_vacation
          group.update_attributes in_vacation: true
        end
      else
        if group.in_vacation
          group.update_attributes in_vacation: false
        end
      end
    end
  end

  private

  def default_values
    self.price ||= 0
    self.in_vacation ||= false
    if changes[:active]
      if active
        users.each do |user|
          Relationship.find_by(user_id: user, group_id: id).set_color
        end
      else
        users.each do |user|
          relationship = Relationship.find_by(user_id: user, group_id: id)
          relationship.color = nil
          relationship.save
        end
      end
    end
  end
end
