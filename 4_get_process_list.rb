#----------------------------------------------------------------------
# 4_get_process_list.rb
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

def get_processes ( application = nil )
  processes = []
  api = "/rest/deploy/applicationProcess"

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
    processes = JSON.parse(response.body)
    processes.select! {|process| ((process["application"])["name"]) == application } if application
	else
		puts(__method__.to_s + ": ERROR: HTTP error was returned." + response.to_s)
	end
  return processes

rescue Exception => e
  puts(__method__.to_s + ": EXCEPTION: " + e.message + ", class = " + e.class.to_s)
  return processes
end

processes = get_processes( UCD_APPLICATION )
# processes = get_processes       # If you want to get all Application Processes.
p processes
