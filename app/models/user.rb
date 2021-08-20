# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  role                   :integer
#  avatar                 :string
#  avatar_gravity         :integer
#  password_changed_at    :datetime
#  locked_at              :datetime
#  failed_attempts        :integer
#  unlock_token           :string
#

class User < ApplicationRecord
  extend LightSearch
  extend ImageGravity
  include ActiveModel::Validations

  enum role: %w(user admin).freeze
  after_initialize :set_default_role, if: -> { new_record? }

  gravity_enum :avatar
  mount_uploader :avatar, AvatarUploader

  light_search_by :name, :email

  has_many :login_activities

  scope :admins, -> { where 'users.role = 1' }
  scope :users, -> { where 'users.role = 0' }

  paginates_per 10

  add_to_dashboard size: 1, weight: 2, columns: [:user_card, actions: [:edit,
   destroy: {method: :delete}]]

  validates :email, presence: true, 'valid_email_2/email': true
  validates :first_name, :last_name, presence: true

  before_validation do
    self.encrypted_password = nil if password != password_confirmation
  end

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :secure_validatable,
         :password_archivable, email_validation: false

  def name
    'user_name'.t(first_name: first_name, last_name: last_name)
  end

  def is_super_admin?
    self.is_admin?
  end

  def is_admin?
    self.role == 'admin'
  end

  def password_required?
    !encrypted_password.present?
  end

  def self.send_reset_password_instructions attributes={}, congress=nil
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

protected

  def set_default_role
    self.role ||= :user
  end
end
