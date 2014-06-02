require 'fileutils'

desc 'Compile all the assets named in config.assets.precompile with and without appended digests'
task 'assets:precompile' do
  assets = JSON.parse(File.read('public/assets/manifest.json'))['assets']

  assets.each do |asset, digested_asset|
    FileUtils.cp("public/assets/#{digested_asset}", "public/assets/#{asset}", verbose: true)
  end
end
