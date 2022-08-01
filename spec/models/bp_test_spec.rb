# == Schema Information
#
# Table name: bp_tests
#
#  id             :integer          not null, primary key
#  image          :string
#  pdf            :string
#  int            :integer
#  json           :json
#  markdown       :text
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  enum           :integer
#  approved_at    :datetime
#  validated_at   :datetime
#  sequence       :integer
#  image_gravity  :integer
#  image_alt_text :string
#  visual         :string
#  visual_regions :json
#

describe BpTest, type: :model do
  it "should implement #caption" do
    t = create(:bp_test)
    expect(t.caption).to eq "Test ##{t.id}"
  end

  it 'should have a multiple enum' do
    t = create(:bp_test)
    t2 = create(:bp_test)

    expect(t.multiple_enum).to eq(['foo', 'bar'])

    expect(t.multiple_enum_foo?).to eq true
    expect(t.multiple_enum_bar?).to eq true

    t.multiple_enum_baz!

    expect(t.multiple_enum_foo?).to eq true
    expect(t.multiple_enum_bar?).to eq true
    expect(t.multiple_enum_baz?).to eq true

    expect(BpTest.multiple_enum_baz).to eq([t])
    expect(BpTest.multiple_enum_bar.order(:id)).to eq([t,t2])
    expect(BpTest.multiple_enum_foo.order(:id)).to eq([t,t2])
  end
end
