# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string
#  last_name                 :string
#  role                      :integer
#  avatar                    :string
#  password_changed_at       :datetime
#  locked_at                 :datetime
#  failed_attempts           :integer
#  unlock_token              :string
#  avatar_regions            :json
#  encrypted_otp_secret      :string
#  encrypted_otp_secret_iv   :string
#  encrypted_otp_secret_salt :string
#  consumed_timestep         :integer
#  otp_required_for_login    :boolean
#  otp_backup_codes          :string           is an Array
#

class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true
  encrypts :first_name, deterministic: true
  encrypts :last_name, deterministic: true

  extend LightSearch
  include ImageVersions
  include ActiveModel::Validations

  enum role: %w(user admin).freeze
  after_initialize :set_default_role, if: -> { new_record? }

  mount_uploader :avatar, AvatarUploader
  expose_versions_for :avatar, {
    thumb: [60, 60],
    profile: [128, 128],
    medium: [300, 300],
  }

  light_search_by :name, :email

  has_many :login_activities

  scope :admins, -> { where 'users.role = 1' }
  scope :users, -> { where 'users.role = 0' }

  paginates_per 10

  add_to_dashboard size: 1, weight: 2, columns: [
    :user_card,
    actions: [
      :edit,
      destroy: {method: :delete}
    ]
  ]

  validates :email, presence: true, 'valid_email_2/email': true
  validates :first_name, :last_name, presence: true

  before_validation do
    self.encrypted_password = nil if password != password_confirmation
  end

  devise :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :secure_validatable,
         :password_archivable, email_validation: false

  devise :two_factor_authenticatable, :two_factor_backupable,
         otp_backup_code_length: 10,
         otp_number_of_backup_codes: 10,
         otp_secret_encryption_key: ENV['OTP_SECRET_KEY']

  def name
    'user_name'.t(first_name: first_name, last_name: last_name)
  end

  def is_super_admin?
    self.is_admin?
  end

  def is_admin?
    self.role == 'admin'
  end

  def self.send_reset_password_instructions attributes={}, congress=nil
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  # Generate an OTP secret it it does not already exist
  def generate_two_factor_secret_if_missing!
    return unless otp_secret.nil?
    update!(otp_secret: User.generate_otp_secret)
  end

  # Ensure that the user is prompted for their OTP when they login
  def enable_two_factor!
    update!(otp_required_for_login: true)
  end

  # Disable the use of OTP-based two-factor.
  def disable_two_factor!
    update!(
        otp_required_for_login: false,
        otp_secret: nil,
        otp_backup_codes: nil)
  end

  # URI for OTP two-factor QR code
  def two_factor_qr_code_uri
    issuer = ENV['OTP_2FA_ISSUER_NAME']
    label = ['app_name'.t, email].join(':')

    otp_provisioning_uri(label, issuer: issuer)
  end

  # Determine if backup codes have been generated
  def two_factor_backup_codes_generated?
    otp_backup_codes.present?
  end

protected

  def set_default_role
    self.role ||= :user
  end
end
