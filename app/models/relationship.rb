# Model for linking users to groups
class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def set_color
    relationships = Relationship.where('user_id = ? AND color NOT NULL', user_id)
    used_colors = Array.new
    relationships.each {|relationship| used_colors.append relationship.color}
    COLORS.each do |color|
      next if used_colors.include?(color)
      self.color = color
      save
      break
    end
  end

end
