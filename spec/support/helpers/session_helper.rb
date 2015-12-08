require File.expand_path('../base_helper', __FILE__)

module SessionHelper
  extend BaseHelper

  module ExampleMethods
    def setup_devise
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    def login user
      user = FactoryGirl.create(user) if user.is_a? Symbol

      @current_user = user
      setup_devise
      sign_in user
    end

    def auth user, opts={}
      user = FactoryGirl.create(user) if user.is_a? Symbol
      ActiveSupport::OptionMerger.new self, opts.merge(auth_token: user.authentication_token)
    end

    def json opts={}
      ActiveSupport::OptionMerger.new self, opts.merge(format: :json)
    end

    def json_response
      response.body && JSON.parse(response.body)
    end
  end

  module ExampleGroupMethods
    User.roles.keys.each do |k|
      class_eval <<-RUBY
        def as_#{k}(options={})
          { factory: :#{k}, label: '#{k}' }.merge(options)
        end
      RUBY
    end

    def when_logged_in(options={}, &block)
      if options.present?
        if options[:as].present?
          label = factory = options[:as]
          traits = []
        elsif options[:factory].present?
          factory = options[:factory]
          label = options[:label] || factory
          traits = options[:traits] || []
        else
          label = factory = :user
          traits = []
        end

        proc = options[:do]
        extra_label = options[:extra_label]

        context "when logged in as #{label}#{extra_label}" do
          let(:user) do
            u = create factory, *traits
            instance_exec(u, &proc) if proc
            u
          end

          before(:each) { sign_in user }

          context('', &block) if block_given?
        end
      else
        context "when not logged in" do
          context('', &block) if block_given?
        end
      end
    end
  end
end
