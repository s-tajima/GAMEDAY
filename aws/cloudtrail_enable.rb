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

  if resp[:trail_list].empty?
    $logger.info "#{region} Empty CloudTrail conig."
    ct.client.create_trail({:name => $ct_name, :s3_bucket_name => $bucket_name})
    $logger.info "#{region} #{$ct_name} Created CloudTrail conig."
  end

  resp = ct.client.describe_trails({:trail_name_list => [$ct_name]}) 
  resp[:trail_list].each do |trail|
    detail = ct.client.get_trail_status({:name => trail[:name]})

    unless detail[:is_logging]
      ct.client.start_logging({:name => trail[:name]})
      $logger.info "#{region} #{trail[:name]} Start logging."
    end

    unless trail[:s3_bucket_name] == $bucket_name
      ct.client.update_trail({:name => trail[:name], :s3_bucket_name => $bucket_name})
      $logger.info "#{region} #{trail[:name]} update bucket_name."
    end

    unless trail[:include_global_service_events]
      ct.client.update_trail({:name => trail[:name], :include_global_service_events => true})
      $logger.info "#{region} #{trail[:name]} enable include_global_service_events."
    end
    $logger.info "#{region} #{trail[:name]} #{trail[:s3_bucket_name]} #{detail[:is_logging]}"
  end
end
