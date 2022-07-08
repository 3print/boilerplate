class StaticController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %w(upload)

  # A special method defined that make a direct upload in lieu of S3
  # when we're not using AWS locally and still want to be able to use the
  # direct upload feature
  if Rails.env.development?
    define_method :upload do
      begin
        uploader = ImageUploader.new

        file = File.new("#{CarrierWave.tmp_path}/#{params[:name]}.#{params[:format]}", 'w+', encoding: 'ascii-8bit')

        file.write request.body.read

        # uploader.class.version_names = ['']
        uploader.send(:cache_id=, '0000-0000-0000-0000')
        uploader.send(:original_filename=, 'fake-s3-file.jpg')
        uploader.instance_variable_set(:@mounted_as, 'fake-s3-uploads')

        uploader.store!(file)

        file.close
      rescue => e
        puts e.message
        puts e.backtrace
      end
    end
  end
end
