class Api::SignedUrlsController < Api::ApiController
  def index
    if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::AWS
      s3 = Aws::S3::Resource.new(region: CarrierWave::Uploader::Base.aws_credentials[:region])
      key = "#{ENV['AWS_ENV']}/uploads/#{SecureRandom.uuid}/#{params[:objectName]}"
      obj = s3.bucket(CarrierWave::Uploader::Base.aws_bucket).object(key)
      put_url = obj.presigned_url(:put, acl: CarrierWave::Uploader::Base.aws_acl, expires_in: 3600 * 24)

      render json: {
        signedUrl: put_url,
        publicUrl: obj.public_url,
      }
    else
      # Here's a special case when running locally without AWS
      # the returned urls allows for an upload through a special
      # route in the rails app, and the returned public url is the
      # one that route will generate
      render json: {
        signedUrl: s3_upload_path(params[:objectName]),
        publicUrl: "/uploads/fake-s3-uploads/#{params[:objectName]}/#{params[:objectName]}"
      }
    end
  end
end
