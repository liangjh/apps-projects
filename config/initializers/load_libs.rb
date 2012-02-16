Saintstir::Application.configure do

  config.autoload_paths += Dir["#{config.root}/lib/**/"]
  puts "loading libraries: #{config.autoload_paths}"

end
