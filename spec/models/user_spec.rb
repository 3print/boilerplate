
describe User do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  context 'when a user does not have an encryted password' do
    subject { build :user, :no_password }

    it 'validates the password and password_confirmation' do
      subject.valid?

      subject.errors.messages[:password].should be_present
      subject.errors.messages[:password_confirmation].should be_present
    end
  end

end
