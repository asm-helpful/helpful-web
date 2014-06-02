require 'fileutils'

desc 'Compile all the assets named in config.assets.precompile with and without appended digests'
task 'assets:precompile' do
  digest = /\-[0-9a-f]{32}\./
  assets = Dir['public/assets/**/*'].select { |asset| asset =~ digest }
  assets.each { |asset| FileUtils.cp(asset, asset.sub(digest, '.'), verbose: true) }
end
