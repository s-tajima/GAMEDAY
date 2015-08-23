require File.expand_path('../bootstrap', __FILE__)

s3 = AWS::S3.new(
  :access_key_id     => $config[:accounts][:access_key_id],
  :secret_access_key => $config[:accounts][:secret_access_key],
)

buckets = s3.buckets
buckets.each do |bucket|
  puts "=== #{bucket.name} ==="
  puts JSON.pretty_generate(bucket.policy.to_h)
  puts bucket.lifecycle_configuration.to_xml
  bucket.cors.each { |rule| puts rule.to_h }
end
