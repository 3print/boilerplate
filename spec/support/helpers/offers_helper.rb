require File.expand_path('../base_helper', __FILE__)

module OffersHelper
  extend BaseHelper

  module ExampleGroupMethods

    def for_each_offer(offers=Settings.offers, &block)
      offers.each do |offer|
        context "for a company with #{offer} offer" do
          let(:company) { create :company, offer_type: offer }
          let(:store) { create :store, company: company }

          class_exec(offer, &block)
        end
      end
    end

    def for_offer(offer, &block)
      context "for a company with #{offer} offer" do
        let(:company) { create :company, offer_type: offer }
        let(:store) { create :store, company: company }

        class_exec(offer, &block)
      end
    end

  end
end
