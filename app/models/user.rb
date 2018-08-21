class User < ApplicationRecord
    validates :name,presence: true , length:{maximum: 30}
    validates :email,presence: true, length:{maximum: 255} ,format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } , uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 3 }
    has_many :pictures , dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorites_pictures,through: :favorites,source: :picture
end
