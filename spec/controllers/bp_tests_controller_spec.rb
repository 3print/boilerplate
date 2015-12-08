require 'rails_helper'

describe BpTestsController do
  describe 'GET index' do
    subject(:do_request) { get :index }

    it_should 'be available', as_admin
    it_should 'be available', as_user
    it_should 'be available'
  end
end
