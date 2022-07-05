class Api::SignedUrlsController < Api::ApiController
  def index
    s3 = Aws::S3::Resource.new(region: CarrierWave::Uploader::Base.aws_credentials[:region])
    key = "#{ENV['AWS_ENV']}/uploads/#{SecureRandom.uuid}/#{params[:objectName]}"
    obj = s3.bucket(CarrierWave::Uploader::Base.aws_bucket).object(key)
    put_url = obj.presigned_url(:put, acl: CarrierWave::Uploader::Base.aws_acl, expires_in: 3600 * 24)

    render json: {
      signedUrl: put_url,
      publicUrl: obj.public_url,
    }
  end
end
