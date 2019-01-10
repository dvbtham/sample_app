class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_length}
  validate :picture_size

  scope :recent_posts, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return if picture.size <= Settings.picture.max_size.megabytes
    errors.add :picture, I18n.t("picture.max_size",
      max_size: Settings.picture.max_size)
  end
end
