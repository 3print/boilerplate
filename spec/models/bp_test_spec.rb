# == Schema Information
#
# Table name: bp_tests
#
#  id           :integer          not null, primary key
#  image        :string(255)
#  pdf          :string(255)
#  int          :integer
#  json         :json
#  markdown     :text
#  text         :text
#  created_at   :datetime
#  updated_at   :datetime
#  enum         :integer
#  approved_at  :datetime
#  validated_at :datetime
#

describe BpTest, type: :model do
  it "should implement #caption" do
    t = create(:bp_test)
    expect(t.caption).to eq "Test ##{t.id}"
  end
end
