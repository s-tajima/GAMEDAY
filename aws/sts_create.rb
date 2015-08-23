require File.expand_path('../bootstrap', __FILE__)
require 'open-uri'
require 'cgi'

sts = AWS::STS.new(
  :access_key_id     => $config[:accounts][:access_key_id],
  :secret_access_key => $config[:accounts][:secret_access_key],
)

policy = AWS::STS::Policy.new
policy.allow(:actions => "ec2:*",:resources => :any)

session = sts.new_federated_session(
  "UserName",
  :policy => policy,
  :duration => 3600)

issuer_url = "https://mysignin.internal.mycompany.com/"
console_url = "https://console.aws.amazon.com/ec2"
signin_url = "https://signin.aws.amazon.com/federation"

session_json = {
  :sessionId => session.credentials[:access_key_id],
  :sessionKey => session.credentials[:secret_access_key],
  :sessionToken => session.credentials[:session_token]
}.to_json

get_signin_token_url = signin_url + "?Action=getSigninToken" + "&SessionType=json&Session=" + CGI.escape(session_json)
returned_content = URI.parse(get_signin_token_url).read

signin_token = JSON.parse(returned_content)['SigninToken']
signin_token_param = "&SigninToken=" + CGI.escape(signin_token)

issuer_param = "&Issuer=" + CGI.escape(issuer_url)
destination_param = "&Destination=" + CGI.escape(console_url)
login_url = signin_url + "?Action=login" + signin_token_param + issuer_param + destination_param
puts login_url

