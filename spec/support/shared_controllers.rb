shared_examples 'a logged action' do
  context 'when logged out' do
    it { should respond_by :redirect }
    it { should redirect_to new_user_session_path }
  end
end

shared_examples 'be unavailable' do |as_user|
  when_logged_in as_user do
    it { should respond_by :forbidden }
  end
end

shared_examples 'be available' do |as_user|
  when_logged_in as_user do
    it { should respond_by :success }
  end
end

shared_examples 'be processable' do |as_user|
  when_logged_in as_user do
    it { should respond_by :redirect }
  end
end

shared_examples 'be unprocessable' do |as_user|
  when_logged_in as_user do
    it { should respond_by :unprocessable }
  end
end

shared_examples 'render' do |tpl, as_user|
  when_logged_in as_user do
    it { should render_template(partial: tpl) }
  end
end
