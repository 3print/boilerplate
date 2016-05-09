require 'rails_helper'
require 'seeder'

def seeds_files(dir)
  Dir[File.join(config.fixture_path, 'seeds', dir, "*.yml")]
end

describe Seeder do
  it 'raises an error on an empty seeds file' do
    expect { Seeder.new(seeds_files('empty')).load }.to raise_error("invalid seeds type for User")
  end

  it 'raises an error on an empty seeds file' do
    expect { Seeder.new(seeds_files('undefined_model')).load }.to raise_error(NameError)
  end

  context 'with a list of seeds at the top level' do
    it 'creates on record for entry in the list' do
      expect { Seeder.new(seeds_files('top_level')).load }.to change { SeoMeta.count }.by 2
    end
  end

  context 'with an options hash at the top level' do
    context 'that does not contain a seeds key' do
      it 'raises an error' do
        expect { Seeder.new(seeds_files('no_seeds')).load }.to raise_error("empty seeds for User")
      end
    end

    context 'that defines a find_by key' do
      it 'queries model using the provided attributes list' do
        expect { Seeder.new(seeds_files('find_by')).load }.to change { User.count }.by 1
      end
    end

    context 'that defines a ignore_in_query key' do
      it 'queries model without the specified attribute list' do
        expect { Seeder.new(seeds_files('ignore_in_query')).load }.to change { User.count }.by 2
      end
    end

    context 'that defines both find_by and ignore_in_query' do
      it 'queries model using only the find by attributes' do
        expect { Seeder.new(seeds_files('both_find_by_and_ignore')).load }.to change { User.count }.by 1
      end
    end

    context 'that defines a priority option' do
      it 'loads the seeds using the provided priority' do
        expect { Seeder.new(seeds_files('priority')).load }.to change { SeoMeta.count }.by 1

        expect(SeoMeta.first.meta_owner).to eq(User.first)
      end
    end
  end

  describe 'custom attribute expressions' do
    describe '_find:' do
      let(:user) { create :user, email: 'foo@foo.com'}
      it 'performs a queries using the specified argument' do
        user

        expect { Seeder.new(seeds_files('attribute_find')).load }.to change { SeoMeta.count }.by 1

        expect(SeoMeta.first.meta_owner).to eq(user)
      end
    end

    describe '_asset:' do
      it 'performs a queries using the specified argument' do
        seeder = Seeder.new(seeds_files('attribute_asset'), {
          asset_path: File.join(Rails.root, 'spec', 'fixtures')
        })

        expect { seeder.load }.to change { User.count }.by 1

        expect(User.first.avatar).to be_present
      end
    end

    describe '_eval:' do
      let(:user) { create :user, email: 'foo@foo.com'}
      it 'performs a queries using the specified argument' do
        user

        expect { Seeder.new(seeds_files('attribute_eval')).load }.to change { SeoMeta.count }.by 1

        expect(SeoMeta.first.meta_owner).to eq(user)
      end
    end
  end
end
