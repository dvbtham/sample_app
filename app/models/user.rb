class User < ApplicationRecord
  attr_accessor :gender

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  enum gender: [:male, :female]

  validates :name, :gender, :date_of_birth, presence: true
  validates :name, length: {maximum: Settings.user.name.max_length}
  validates :email, length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED =
    Settings.user.password.max_length
  validates :password, length: {minimum: Settings.user.password.min_length}

  before_save do
    email.downcase!
    gender.to_i
  end

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
