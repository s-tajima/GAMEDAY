require File.expand_path('../bootstrap', __FILE__)

$config[:regions].each do |region|
  ec2 = AWS::EC2.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )
  
  resp = ec2.client.describe_instances
  
  puts "== #{region} ========================================"
  puts JSON.pretty_generate(resp[:reservation_set])
end
