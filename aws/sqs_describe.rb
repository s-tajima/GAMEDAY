require File.expand_path('../bootstrap', __FILE__)

$config[:regions].each do |region|
  sqs = AWS::SQS.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )
  
  puts "== #{region} =="
  puts sqs.queues.map(&:url)
end
