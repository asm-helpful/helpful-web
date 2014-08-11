require 'fileutils'
require 'aws'
require 'securerandom'

WIDGET_ASSETS = {
  'widget.js'         => 'application/javascript',
  'widget-content.js' => 'application/javascript',
  'widget.css'        => 'text/css',
  'widget-arrow.svg'  => 'image/svg+xml',
  'widget-close.svg'  => 'image/svg+xml'
}

desc 'Compile assets and upload widget assets to S3'
task 'assets:precompile' do
  manifest = Dir['public/assets/manifest-*.json'].first
  assets = JSON.parse(File.read(manifest))['assets']


  # Upload the latest widget assets to S3

  s3 = AWS::S3.new(
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )

  bucket = s3.buckets[ENV['S3_BUCKET']]

  assets.each do |asset, digested_asset|
    if WIDGET_ASSETS.has_key?(asset)
      bucket.objects.create(
        "assets/#{asset}",
        File.open("public/assets/#{digested_asset}"),
        acl: :public_read,
        content_encoding: WIDGET_ASSETS[asset]
      )
    end
  end

  # Invalidate the CloudFront cache for those assets

  cf = AWS::CloudFront.new(
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  ).client

  cf.create_invalidation(
    distribution_id: ENV['CLOUDFRONT_DISTRIBUTION'],
    invalidation_batch: {
      paths: {
        quantity: WIDGET_ASSETS.size,
        items: WIDGET_ASSETS.map do |asset, _|
          "/assets/#{asset}"
        end
      },
      caller_reference: SecureRandom.uuid
    }
  )

end
