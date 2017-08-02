CarrierWave.configure do |config|

  config.storage    = :file
  config.cache_dir  = Rails.root.join 'tmp', 'uploads'
  config.asset_host = ENV['ASSET_HOST'] || "http://0.0.0.0:3000"

  if Rails.env.production? || Rails.env.staging? || ENV['FORCE_AWS']
    config.storage = :aws
    config.aws_bucket = ENV['AWS_BUCKET']
    config.aws_acl    = 'public-read'

    config.asset_host = "//#{ ENV['ASSET_HOST'] }"

    config.aws_credentials = {
      access_key_id:      ENV['AWS_ACCESS_KEY_ID'] || ENV['AWS_ACCESS_KEY'],
      secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:             ENV['AWS_REGION'] || 'eu-west-1',
    }

    config.aws_attributes = {
      expires: 1.years.from_now.httpdate,
      cache_control: "max-age=#{ 1.year }"
    }

    config.aws_authenticated_url_expiration = 1.week

  end
end

module PublicUploader
  def self.included base

    if base.storage.name == base.storage_engines[:fog]
      base.asset_host "//#{ ENV['ASSET_HOST'] }"
    end
  end

  def filename
    if original_filename
      # hash = Digest::MD5.hexdigest(File.dirname(current_path))
      base = file.try(:basename) # Local Storage
      unless base.present?
        base = file.try(:filename) #Fog
        base = base.split('.')[0..-2].join('.')
      end
      name = base.split('_').last.gsub(/\.$/, '')

      # ["#{name}-#{hash}", file.extension].compact.select(&:present?).join('.')
      [name, file.extension].compact.select(&:present?).join('.')
    end
  end

  def rmagick_image
    ::Magick::Image.from_blob(self.read).first
  end
end
