class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :validatable
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 30 }
  validates :date_of_birth, presence: true
  VALID_PHONE_NUMBER_REGEX = /\A\d+\z/
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :phone_number, presence: true, length: { is: 9},
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, if: :no_parent?
  validates :preferred_language, presence: true,
                                 inclusion: { in: %w[Romanian Russian English] }
  validates :password, length: { minimum: 6 }, if: :no_parent?, allow_nil: true
  validates :password, confirmation: { case_sensitive: true }
  before_save :default_values
  has_many :relationships, dependent: :destroy
  has_many :groups, through: :relationships
  has_many :posts
  has_many :attendances, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :children, class_name: :User, foreign_key: :parent
  belongs_to :parent, class_name: :User, optional: true


  def full_name
    "#{last_name} #{first_name}"
  end

  def become_teacher
    add_role :teacher
    remove_role :student
  end

  def become_admin
    add_role :admin
    add_role :editor
    remove_role :student
  end

  def become_editor
    add_role :editor
    remove_role :student
  end

  def become_parent
    add_role :parent
  end

  def become_student
    add_role :student
  end

  def admin?
    has_role? :admin
  end

  def teacher?
    has_role? :teacher
  end

  def student?
    has_role? :student
  end

  def editor?
    has_role? :editor
  end

  def parent?
    has_role? :parent
  end

  def child?
    !parent.nil?
  end

  def no_parent?
    parent.nil?
  end

  def discount_percentage
    (discount * 100).to_i.to_s
  end

  def locale
    case preferred_language
    when 'Romanian'
      'ro'
    when 'Russian'
      'ru'
    when 'English'
      'en'
    end
  end

  def lessons
    groups = self.groups
    lessons = Array.new
    groups.each { |group| lessons += group.lessons }
    lessons.sort_by { |lesson| [lesson.week_day, lesson.start_time] }
  end

  def self.assign_roles
    User.all.each(&:become_student)
    User.first.become_admin
    User.find(2).become_admin
    User.find(3).become_admin
    User.find(3).become_teacher
    User.find(3).become_parent
    User.find(4).become_teacher
    User.find(5).become_teacher
  end

  def has_confirmed_children?
    children.each do |child|
      if child.admin_confirmed == true
        return true
      end
    end
    return false
  end

  def calculate_invoice
    price = 0
    groups.where(active: true).each do |group|
      next_start_date = Date.today.at_beginning_of_month.next_month
      next_end_date = Date.today.next_month.end_of_month
      previous_start_date = Date.today.at_beginning_of_month
      previous_end_date = Date.today.at_end_of_month
      nr_of_lessons = 0
      nr_of_absences = 0
      group.lessons.each do |lesson|
        next_lesson_days = (next_start_date..next_end_date).to_a.select { |k| k.wday == lesson.week_day }
        previous_lesson_days = (previous_start_date..previous_end_date).to_a.select { |k| k.wday == lesson.week_day }
        next_lesson_days = next_lesson_days.to_set
        vacation_days = Set[]
        Vacation.where('end_date >= ? AND start_date <= ? AND kind = ?', next_start_date, next_end_date, group.kind).each do |vacation|
          vacation_days = vacation_days.merge((vacation.start_date..vacation.end_date).to_set.select { |k| k.wday == lesson.week_day})
        end
        previous_lesson_days.each do |date|
          lesson_start = Time.new(date.year, date.month, date.day, lesson.start_time.hour, lesson.start_time.min)
          lesson_end = Time.new(date.year, date.month, date.day, lesson.end_time.hour, lesson.end_time.min)
          lesson_attendance = group.attendances.where('time >= ? AND time <= ?', lesson_start, lesson_end)
          if lesson_attendance.count > 0 && lesson_attendance.where('user_id = ?', id).count == 0
            nr_of_absences += 1
          end
        end
        nr_of_lessons += (next_lesson_days - vacation_days).size
      end
      price += nr_of_lessons * group.price * (1 - discount)
      price -= nr_of_absences * group.price * (1 - discount) * 0.3
    end
  end

  def self.send_invoice_notifications
    User.with_role(:student).each do |user|
      to_pay = 0
      if user.children.count == 0
        to_pay = user.calculate_invoice
      else
        user.children.each do |child|
          to_pay += child.calculate_invoice
        end
      end
      if to_pay > 0
        user.notifications.build(title: 'Invoice received', content: "Amount due for #{Date::MONTHNAMES[Date.today.next_month.month]} is #{to_pay}")
      end
    end
  end

  private

  def default_values
    self.discount ||= 0
    self.admin_confirmed ||= false
  end
end
