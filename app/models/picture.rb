class Picture < ApplicationRecord
    validates :image, presence: true
    validates :comment, 
    length:{ in: 0..140 ,:message =>'は300文字以下でお願いします。'}
    belongs_to :user
    has_many :favorites,dependent: :destroy
    has_many :favorite_users,through: :favorites,source: :user
    mount_uploader :image, ImageUploader #アップローダーへの紐づけ
end
