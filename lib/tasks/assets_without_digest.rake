require 'fileutils'

desc 'Compile all the assets named in config.assets.precompile with and without appended digests'
task 'assets:precompile' do
  digest = /\-[0-9a-f]{32}\./

  assets = Dir['public/assets/**/*'].select { |asset| asset =~ digest }.
    map { |asset| [asset, asset.sub(digest, '.')] }

  assets.each do |asset, nondigest|
    if !File.exist?(nondigest) || File.mtime(asset) > File.mtime(nondigest)
      FileUtils.cp(asset, nondigest, verbose: true)
    end
  end
end
