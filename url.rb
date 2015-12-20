#!/usr/bin/env ruby

require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "uri"
require "net/https"
require "rexml/document"
require "time"

#
# Sample request to Alexa Web Information Service
#

  access_key_id,secret_access_key = File.read('/home/lou/Downloads/rootkey.csv').split.collect{|x|x.split('=')}.collect{|z|z[1]}
  site = ARGV[0]

SERVICE_HOST = "awis.amazonaws.com"

# escape str to RFC 3986
def escapeRFC3986(str)
  return URI.escape(str,/[^A-Za-z0-9\-_.~]/)
end

action = "UrlInfo"
responseGroup = "Rank,ContactInfo,LinksInCount"
timestamp = ( Time::now ).utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")

query = {
  "Action"           => action,
  "AWSAccessKeyId"   => access_key_id,
  "Timestamp"        => timestamp,
  "ResponseGroup"    => responseGroup,
  "SignatureVersion" => 2,
  "SignatureMethod"  => "HmacSHA1",
  "Url"              => site
}


query_str = query.sort.map{|k,v| k + "=" + escapeRFC3986(v.to_s())}.join('&')

sign_str = "GET\n" + SERVICE_HOST + "\n/\n" + query_str 

puts "String to sign:\n#{sign_str}\n\n"

signature = Base64.encode64( OpenSSL::HMAC.digest( OpenSSL::Digest.new( "sha1" ), secret_access_key, sign_str)).strip
query_str += "&Signature=" + escapeRFC3986(signature)

url = URI.parse("http://" + SERVICE_HOST + "/?" + query_str)

puts "Making request to:\n#{url}\n\n"

xml  = REXML::Document.new( Net::HTTP.get(url) )

print "Response:\n\n"
print "Links in count: "
REXML::XPath.each(xml,"//aws:LinksInCount"){|el| puts el.text}
print "Rank: "
REXML::XPath.each(xml,"//aws:Rank"){|el| puts el.text}

