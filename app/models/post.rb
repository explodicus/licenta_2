class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, PostImageUploader
  validates :content, presence: true
  validates :title, presence: true
  validates :short_content, length: { maximum: 300 }
  validate  :image_size

  private

  # Validates the size of an uploaded picture.
  def image_size
    errors.add(:picture, 'should be less than 5MB') if image.size > 5.megabytes
  end

end
