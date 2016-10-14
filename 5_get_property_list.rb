#----------------------------------------------------------------------
# 5_get_property_list.rb
#
# by Naomi Zenge
#----------------------------------------------------------------------
require 'net/https'
require 'json'

UCD_USERID = <USERID>
UCD_PASSWORD = <PASSWORD>
UCD_URI = <UCD_SERVER>
UCD_TIMEOUT = 30
UCD_PROCESS_VERSION = 20

def get_properties ( process_id, process_version )
  properties = []
  api = "/rest/deploy/applicationProcess/#{process_id}/#{process_version}/propDefs"

	uri = URI.parse(UCD_URI + api)
	https = Net::HTTP.new(uri.host,uri.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	https.open_timeout = UCD_TIMEOUT
	https.read_timeout = UCD_TIMEOUT

	request = Net::HTTP::Get.new(uri.path)
	request["user-agent"] = "Ruby/#{RUBY_VERSION} sample"
	request.basic_auth(UCD_USERID, UCD_PASSWORD)

	response = https.request(request)

	case response
	when Net::HTTPSuccess, Net::HTTPRedirection
    begin
      properties = JSON.parse(response.body)
    rescue
      ## Hack. Ruby NET does not decode in some cases.
      gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
      properties = JSON.parse(gz.read)
    end
	else
		puts(__method__.to_s + ": ERROR: HTTP error was returned." + response.to_s)
	end
  return properties

rescue Exception => e
  puts(__method__.to_s + ": EXCEPTION: " + e.message + ", class = " + e.class.to_s)
  return properties
end

components = get_properties( UCD_PROCESS_ID, UCD_PROCESS_VERSION )
p components
