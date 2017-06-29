# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  role                   :integer
#  avatar                 :string(255)
#  avatar_meta            :text
#  avatar_gravity         :integer
#

class User < ApplicationRecord
  extend Concerns::LightSearch
  extend Concerns::ImageGravity

  enum role: %w(user admin)
  after_initialize :set_default_role, :if => :new_record?

  gravity_enum :avatar
  mount_uploader :avatar, AvatarUploader

  light_search_by :name, :email

  scope :admins, -> { where 'users.role = 1' }

  paginates_per 10

  add_to_dashboard size: 1, weight: 2, columns: [:user_card, actions: [:edit, masquerade: :user_masquerade_path, destroy: {method: :delete}]]

  validates :email, :first_name, :last_name, presence: true
  validates :password, :password_confirmation, presence: true, if: :password_required?

  before_save do
    self.avatar_meta = nil if avatar_meta.is_a?(String)
  end

  before_validation do
    self.encrypted_password = nil if password != password_confirmation
  end

  devise :database_authenticatable, :registerable, :masqueradable,
         :recoverable, :rememberable, :trackable, :validatable

  def name
    'user_name'.t(first_name: first_name, last_name: last_name)
  end

  def super_admin?
    self.admin?
  end

  def admin?
    self.role == 'admin'
  end

  def password_required?
    !encrypted_password.present?
  end

  def self.send_reset_password_instructions attributes={}
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

protected

  def set_default_role
    self.role ||= :user
  end
end
