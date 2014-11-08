require File.expand_path('../bootstrap', __FILE__)

$ct_name     = 's-tajima-cloudtrail'
$bucket_name = ARGV.shift

$config[:regions].each do |region|

  ct = AWS::CloudTrail.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )

  resp = ct.client.describe_trails({:trail_name_list => [$ct_name]}) 
  resp[:trail_list].each do |trail|
    detail = ct.client.get_trail_status({:name => trail[:name]})
    $logger.info "#{region} #{trail[:name]} #{trail[:s3_bucket_name]} #{detail[:is_logging]}"
  end
end
