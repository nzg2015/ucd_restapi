#----------------------------------------------------------------------
# 6_set_property.rb
#
# by Naomi Zenge
#----------------------------------------------------------------------
require 'net/https'
require 'json'

UCD_USERID = <USERID>
UCD_PASSWORD = <PASSWORD>
UCD_URI = <UCD_SERVER>
UCD_APPLICATION = <UCD_APPLICATION>
UCD_TIMEOUT = 30
UCD_PROCESS_ID = '8224cb11-1c08-48a6-92bf-8c90174ab5f4'
UCD_PROPERTY = '{"applicationProcessVersion": 30, 
                 "description": "Test Property set by REST API", 
                 "existingId": "", 
                 "label": "Test Property", 
                 "name": "test_property", 
                 "pattern": "", 
                 "required": "false", 
                 "type": "TEXT", 
                 "value": "Hello World"}'

def set_property ( process_id, property )
  api = "/rest/deploy/applicationProcess/#{process_id}/savePropDef"

	uri = URI.parse(UCD_URI + api)
	https = Net::HTTP.new(uri.host,uri.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	https.open_timeout = UCD_TIMEOUT
	https.read_timeout = UCD_TIMEOUT

	request = Net::HTTP::Put.new(uri.path)
	request["user-agent"] = "Ruby/#{RUBY_VERSION} sample"
	request.basic_auth(UCD_USERID, UCD_PASSWORD)

  request.body = property
  response = https.request(request)

	case response
	when Net::HTTPSuccess, Net::HTTPRedirection
    ##
  else    
		puts(__method__.to_s + ": ERROR: HTTP error was returned." + response.to_s)
	end
  return

rescue Exception => e
  puts(__method__.to_s + ": EXCEPTION: " + e.message + ", class = " + e.class.to_s)
  return properties
end

set_property( UCD_PROCESS_ID, UCD_PROPERTY )

