class User < ActiveRecord::Base
  extend CarrierWave::Meta::ActiveRecord

  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  mount_uploader :avatar, AvatarUploader

  serialize :avatar_meta, OpenStruct

  carrierwave_meta_composed :avatar_meta, :avatar, image_version: %i(width height md5sum)

  scope :admins, -> { where 'users.role = 1' }

  paginates_per 10

  validates :email, :first_name, :last_name, presence: true
  validates :password, :password_confirmation, presence: true, if: :password_required?

  before_save do
    self.avatar_meta = nil if avatar_meta.is_a?(String)
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def name
    'user_name'.t(first_name: first_name, last_name: last_name)
  end

  def admin?
    self.role == 'admin'
  end

  def password_required?
    !encrypted_password.present?
  end

protected

  def set_default_role
    self.role ||= :user
  end
end
