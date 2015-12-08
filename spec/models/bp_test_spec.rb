require 'rails_helper'

RSpec.describe BpTest, type: :model do
  it "should implement #caption" do
    t = create(:bp_test)
    expect(t.caption).to eq "Test ##{t.id}"
  end
end
