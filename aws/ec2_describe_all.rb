require File.expand_path('../bootstrap', __FILE__)

$config[:regions].each do |region|
  ec2 = AWS::EC2.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )
  
  methods = ec2.client.methods.select {|m| m =~ /^describe_/}

  methods.delete(:describe_image_attribute)
  methods.delete(:describe_images)
  methods.delete(:describe_instance_attribute)
  methods.delete(:describe_network_interface_attribute)
  methods.delete(:describe_reserved_instances_listings)
  methods.delete(:describe_snapshot_attribute)
  methods.delete(:describe_snapshots)
  methods.delete(:describe_spot_datafeed_subscription)
  methods.delete(:describe_volume_attribute)
  methods.delete(:describe_vpc_attribute)
  methods.delete(:describe_spot_price_history)

  methods.each do |m|
    puts "== #{region}:#{m} ========================================"
    result = ec2.client.method(m).call
    result.delete(:request_id)
    puts JSON.pretty_generate(result.data)
  end
  exit
end
