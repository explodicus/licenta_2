if Rails.env.production?
    CarrierWave.configure do |config|
      config.fog_provider = 'fog/aws'                        # required
      config.fog_credentials = {
          provider:              'AWS',                        # required
          use_iam_profile:       true,                         # optional, defaults to false
          aws_access_key_id:      ENV['S3_ACCESS_KEY'],
          aws_secret_access_key:  ENV['S3_SECRET_KEY'],
          region:                ENV['S3_REGION'],                  # optional, defaults to 'us-east-1'
      }
      config.fog_directory  = ENV['S3_BUCKET']                                      # required
      config.fog_public     = false                                                 # optional, defaults to true
    end
  end