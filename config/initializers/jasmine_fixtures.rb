JasmineFixtures = proc do |env|
  Rack::Directory.new('spec/javascripts/fixtures').call(env)
end
