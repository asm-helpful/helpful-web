require 'fileutils'

WIDGET_ASSETS = [
  'widget.js',
  'widget-content.js',
  'widget.css',
  'widget-arrow.svg',
  'widget-close.svg'
]

desc 'Compile assets and upload widget assets to S3'
task 'assets:precompile' do
  manifest = Dir['public/assets/manifest-*.json'].first
  assets = JSON.parse(File.read(manifest))['assets']

  connection = Fog::Storage.new(
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )

  directory = connection.directories.get(ENV['FOG_DIRECTORY'])

  assets.each do |asset, digested_asset|
    if WIDGET_ASSETS.include?(asset)
      directory.files.create(
        key: "assets/#{asset}",
        body: File.open("public/assets/#{digested_asset}"),
        public: true
      )
    end
  end
end
