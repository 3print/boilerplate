CarrierWave.configure do |config|

  config.storage    = :file
  config.cache_dir  = Rails.root.join 'tmp', 'uploads'
  config.asset_host = ENV['ASSET_HOST'] || "http://localhost:3000"

  if Rails.env.production? || Rails.env.staging? || ENV['FORCE_AWS']
    config.storage = :aws

    config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:            ENV['AWS_REGION'], # Required
    stub_responses:    Rails.env.test?,
  }

    config.aws_bucket  = ENV['AWS_BUCKET']
    config.aws_acl     = ENV['AWS_ACL']
    config.asset_host  = "https://#{ENV['ASSET_HOST']}"

    config.aws_attributes = {
      cache_control: "max-age=#{ 1.year }",
    }
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
  end
end

module PublicUploader
  def self.included base
    # if Rails.env.production?
    if base.storage.name == base.storage_engines[:aws]
      base.asset_host   "https://#{ENV['ASSET_HOST']}"
      base.aws_acl ENV['AWS_ACL']
    end
  end
end
