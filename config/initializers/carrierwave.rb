CarrierWave.configure do |config|

  config.storage    = :file
  config.cache_dir  = Rails.root.join 'tmp', 'uploads'
  config.asset_host = ENV['ASSET_HOST'] || "http://0.0.0.0:3000"

  if Rails.env.production? || Rails.env.staging? || ENV['FORCE_AWS']
    config.storage = :fog

    config.fog_credentials = {
      provider:               'AWS',
      region:                 'eu-west-1',
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'] || ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      path_style:             true
    }

    config.fog_directory  = ENV['AWS_BUCKET']
    config.asset_host     = "https://#{ ENV['ASSET_HOST'] }"
    config.fog_public     = true

    config.fog_attributes = { 'Cache-Control' => "max-age=#{ 1.year }" }
    config.fog_authenticated_url_expiration = 10.years
  end
end

module PublicUploader
  def self.included base

    # if Rails.env.production?
    if base.storage.name == base.storage_engines[:fog]
      base.asset_host   "http://#{ ENV['ASSET_HOST'] }"
      base.fog_public   true
    end
  end
end
