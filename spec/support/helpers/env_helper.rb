require File.expand_path('../base_helper', __FILE__)

module EnvHelper
  extend BaseHelper
  module ExampleGroupMethods
    def in_env env_name, &block
      context "in environment #{env_name}" do
        before(:each) { Rails.stub(env: ActiveSupport::StringInquirer.new(env_name.to_s)) }
        context('', &block) if block_given?
      end
    end
  end
end
