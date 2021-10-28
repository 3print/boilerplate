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

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  context 'with a short password' do
    subject { build :user, password_confirmation: 'foo', password: 'foo' }

    it 'validates the length of the password' do
      subject.valid?

      expect(subject.errors["password"]).to be_present
    end
  end

  context 'when a user does not have an encryted password' do
    subject { build :user, :no_password }

    it 'validates the password' do
      subject.valid?

      expect(subject.errors[:password]).to be_present
    end
  end

  context 'when the password confirmation does not match the password' do
    subject { build :user, password_confirmation: 'barBar1§' }

    it 'raises an error for the confirmation' do
      subject.valid?

      expect(subject.errors[:password]).not_to be_present
      expect(subject.errors[:password_confirmation]).to be_present
    end
  end

  context 'setting the same password when updating the record' do
    subject { build :user }
    it 'raises a exception' do
      subject.save

      subject.password = "plEase123^"

      subject.valid?

      expect(subject.errors[:password]).to be_present
    end
  end

end
