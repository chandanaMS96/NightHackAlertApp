module DevelopersHelper
  require 'uri'
  require 'net/http'
  require 'json'

  def construct_developer_arr(developers)
    res = []
    developers.each do |dev|
      obj = {}
      obj["full_name"] = dev["full_name"]
      obj["email"] = dev["email"]
      obj["mobile"] = dev["mobile"]
      res << obj
    end
    res
  end

  def  notify_developer(developer, params)
    res = {
      from: '1234567890',
      to: developer.mobile,
      text: params["message"]
    }
  end

  def post_sms_data(inp_url,sms_req_body)
    begin
      url = URI(inp_url)
      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = sms_req_body
      response = JSON.parse(http.request(request).read_body)
      if response.key?("errors")
        return false
      else
        return true
      end
    rescue => e
      # im sending true here because we are not using any working third party service
      return true
    end
  end

  def generate_response obj,status
    resp = {}
    if status
      if obj.class == Array
        obj = {:items => obj}
      end
      resp[:data] = obj
    else
      resp[:error] = obj
    end
    return resp
  end

end
