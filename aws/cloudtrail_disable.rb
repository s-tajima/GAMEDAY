require File.expand_path('../bootstrap', __FILE__)

$config[:regions].each do |region|

  ct = AWS::CloudTrail.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )
  resp = ct.client.describe_trails
  resp[:trail_list].each do |trail|
     ct.client.delete_trail({:name => trail[:name]})
     $logger.info "#{region} Deleted #{trail[:name]}"
  end
end
