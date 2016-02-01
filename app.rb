# encoding: utf-8
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

get "/" do
  ""
end

post "/" do
  response = ""
begin
  puts "[LOG] #{params}"
  unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
    response = { text: "From the collection:" }
    response[:attachments] = [ generate_attachment ]
    response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
    response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
    response = response.to_json
  end
end
  status 200
  body response
end

def generate_attachment
  uri = "http://scrapi.org/random?fields=title,primaryImageUrl,url"
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  @scrapiresults = JSON.parse(request.body)
  puts "[LOG] #{@scrapiresults}"

# so many nil checks this is garbage rewrite me

  if @scrapiresults["title"].nil?
    get_title = "Unknown"
  else
    get_title = @scrapiresults["title"]
  end

  if @scrapiresults["primaryImageUrl"].nil?
    get_imageurl = ""
  else
    get_imageurl = @scrapiresults["primaryImageUrl"]
  end

  if @scrapiresults["url"].nil?
    get_url = ""
  else
    get_url = @scrapiresults["primaryImageUrl"]
  end

  checkurl = URI.parse(get_url)
  unless checkurl.kind_of?(URI::HTTP) or checkurl.kind_of?(URI::HTTPS)
    get_url = "http://metmuseum.org#{get_url}"
  end

  checkimageurl = URI.parse(get_imageurl)
  unless uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
    get_imageurl = ""
  end

  response = { title: "#{get_title}", title_link: "#{get_url}", image_url: "#{get_imageurl}", text: "" }

end
