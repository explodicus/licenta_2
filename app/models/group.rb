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

  def find_lesson(lesson_time)
    converted_lesson_time = Time.new(2000, 1, 1, lesson_time.hour,
                                     lesson_time.min)
    lessons.find_by('week_day = ? AND start_time < ? AND end_time > ?',
                    lesson_time.wday, converted_lesson_time,
                    converted_lesson_time)
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
