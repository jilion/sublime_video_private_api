guard :rspec, bundler: false, all_after_pass: false, all_on_start: false, keep_failed: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^(app|spec/dummy/app)/controllers/(.+)\.rb$})  { "spec/integration/server_spec.rb" }
  watch('lib/sublime_video_private_api/model.rb')     { "spec/integration/client_spec.rb" }

  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end

