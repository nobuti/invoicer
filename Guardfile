guard 'sass', :input => 'assets/css', :output => 'public/css', :style => :nested

guard 'sprockets', :destination => 'public/js', :asset_paths => ['assets/js'], :minify => true, :root_file => 'assets/js/main.js'  do
  watch(%r{assets/js/.+\.(js)})
end

guard 'livereload' do
  watch(%r{^app\.rb})
  watch(%r{views/.+\.(erb|haml|slim)$})
  watch(%r{css/.+\.(css)})
  watch(%r{js/.+\.(js)})
end