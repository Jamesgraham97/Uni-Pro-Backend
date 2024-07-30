# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :course_modules, dependent: :destroy
  has_many :assignments

  has_many :team_members
  has_many :teams, through: :team_members
  has_many :projects, through: :teams
  has_many :project_assignments, through: :projects

  has_one_attached :profile_picture
  has_many :notifications, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  def friendship_status(other_user)
    friendship = friendships.find_by(friend_id: other_user.id) || inverse_friendships.find_by(user_id: other_user.id)
    return 'not_friends' if friendship.nil?
    return 'pending' if friendship.status == 'pending'

    'accepted' if friendship.status == 'accepted'
  end

  def as_json(options = {})
    super(options.merge(methods: [:profile_picture_url]))
  end

  def profile_picture_url
    Rails.application.routes.url_helpers.rails_blob_url(profile_picture, only_path: true) if profile_picture.attached?
  end

  # Validations
  validates :display_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
