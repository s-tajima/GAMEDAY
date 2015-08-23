require File.expand_path('../bootstrap', __FILE__)

$config[:regions].each do |region|
  ec2 = AWS::EC2.new(
    :access_key_id     => $config[:accounts][:access_key_id],
    :secret_access_key => $config[:accounts][:secret_access_key],
    :region            => region
  )

  instance_names = Array.new

  ec2.instances.each do |instance|
    instance_names << instance.tags[:Name]
  end

  instance_names.shuffle!

  ec2.instances.each do |instance|
    before = instance.tags[:Name]
    after  = instance_names.shift
    instance.tags[:Name] = after
    $logger.info "#{region} rename instance #{instance.id} #{before} to #{after}"
  end
end
