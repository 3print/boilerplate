# == Schema Information
#
# Table name: seo_meta
#
#  id              :integer          not null, primary key
#  meta_owner_id   :integer
#  meta_owner_type :string(255)
#  title           :string(255)
#  description     :text
#  static_action   :string(255)
#  static_mode     :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe SeoMeta, type: :model do
  it { should belong_to :meta_owner }

  context 'when static_mode is disabled' do
    it 'validates the meta owner type' do
      meta = build(:seo_meta)

      meta.valid?

      expect(meta.errors.messages[:meta_owner_type]).not_to be_nil
    end
  end

  context 'when static_mode is enabled' do
    it 'validates the static action field' do
      meta = build(:seo_meta, static_mode: true)

      meta.valid?

      expect(meta.errors.messages[:static_action]).not_to be_nil
    end
  end
end
