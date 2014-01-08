CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads" #Heroku fix
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
    #:region                 => 'eu-west-1' #Set this to speed up uploading if bucket is located outside of US region.
  }
  config.fog_directory  = ENV["FOG_DIRECTORY"]
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  config.storage = Rails.env.production? ? :fog : :file
end