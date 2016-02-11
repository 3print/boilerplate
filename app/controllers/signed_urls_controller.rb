class SignedUrlsController < ApplicationController
  skip_load_and_authorize_resource

  def index
    render json: {
      policy:     s3_upload_policy_document,
      signature:  s3_upload_signature,
      key:        "uploads/#{SecureRandom.uuid}/#{params[:doc][:title]}",
      success_action_redirect: params[:success_action_redirect]
    }
  end

  private

  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document
    conditions = [
      { bucket: CarrierWave::Uploader::Base.fog_directory },
      # { acl:    CarrierWave::Uploader::Base.fog_public ? 'public-read' : 'private' },
      { acl:    'public-read' },
      [ "starts-with", "$key", "uploads/" ],
      { success_action_status: '201' }
    ]

    if params[:success_action_redirect].present?
      conditions << { success_action_redirect: params[:success_action_redirect] }
    end

    Base64.encode64(
    {
      expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
      conditions: conditions
    }.to_json
    ).gsub(/\n|\r/, '')
  end

  # sign our request by Base64 encoding the policy document.
  def s3_upload_signature
    Base64.encode64(
    OpenSSL::HMAC.digest(
    OpenSSL::Digest::Digest.new('sha1'),
    CarrierWave::Uploader::Base.fog_credentials[:aws_secret_access_key],
    s3_upload_policy_document
    )
    ).gsub(/\n/, '')
  end
end
