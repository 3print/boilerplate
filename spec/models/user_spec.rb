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

describe User do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  context 'when a user does not have an encryted password' do
    subject { build :user, :no_password }

    it 'validates the password and password_confirmation' do
      subject.valid?

      expect(subject.errors.messages[:password]).to be_present
      expect(subject.errors.messages[:password_confirmation]).to be_present
    end
  end

end
