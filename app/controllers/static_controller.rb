class StaticController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %w(upload)

  # A special method defined that make a direct upload in lieu of S3
  # when we're not using AWS locally and still want to be able to use the
  # direct upload feature
  if Rails.env.development?
    define_method :upload do
      begin
        file_name = "#{params[:name]}.#{params[:format]}"
        uploader = FakeS3Uploader.new(file_name)

        file = File.new("#{CarrierWave.tmp_path}/#{file_name}", 'w+', encoding: 'ascii-8bit')

        file.write request.body.read

        uploader.store!(file)

        file.close
      rescue => e
        puts e.message
        puts e.backtrace
      end
    end
  end
end
