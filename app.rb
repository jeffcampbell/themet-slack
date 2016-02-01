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
  params[:text] = params[:text].sub(params[:trigger_word], "")
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
  @user_query = params[:text]
if @user_query.length == 0
  uri = "http://scrapi.org/random?fields=title,whoList/who/name,whenList/when/name,whatList/what/name,primaryImageUrl,url"
else
  @user_query = @user_query.gsub(/ /, '%20')
  uri = "http://scrapi.org/search/#{@user_query}?fields=title,whoList/who/name,whenList/when/name,whatList/what/name,primaryImageUrl,url"
end
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  # Check for a nil response in the array
  @scrapiresults = JSON.parse(request.body)
  puts "[LOG] #{@scrapiresults}"

# so many nil checks this is garbage rewrite me

  if @scrapiresults["title"].nil?
    get_title = "Unknown"
  else
    get_title = @scrapiresults["title"]
  end

  if @scrapiresults["whoList"]["who"].nil?
    get_who = "Unknown"
  else
    get_who = @scrapiresults["whoList"]["who"][0]["name"]
  end

  if @scrapiresults["whenList"]["when"].nil?
    get_when = "Unknown"
  else
    get_when = @scrapiresults["whenList"]["when"][0]["name"]
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

  response = { title: "#{get_title}", title_link: "#{get_url}", image_url: "#{get_imageurl}", text: "", fields: [ { title: "Artist", value: "#{get_who}", short: true }, { title: "Period", value: "#{get_when}", short: true } ] }

end
