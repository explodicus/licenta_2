# frozen_string_literal: true

class Vacation < ApplicationRecord
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :kind, presence: true,
                   inclusion: { in: %w[Weekend Vacation Abroad Academic] }
  validate :end_after_start

  def self.is_vacation(date)
    vacations = Vacation.where('start_date <= ? AND end_date >= ?', date, date)
    if vacations.count > 0
      kind = Set.new
      vacations.each do |vacation|
        kind.add(vacation.kind)
      end
      return kind
    end
    false
  end

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, 'must be after the start date')
    end
  end
end
