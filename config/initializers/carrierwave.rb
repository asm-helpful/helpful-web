CarrierWave.configure do |config|
  # Heroku fix
  config.cache_dir = Rails.root.join('tmp', 'uploads')

  config.storage = if Rails.env.production?
      :aws
    else
      :file
    end

  config.aws_bucket = ENV['S3_BUCKET']
  config.asset_host = ENV['ASSET_HOST']
  config.aws_acl    = :public_read
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end
