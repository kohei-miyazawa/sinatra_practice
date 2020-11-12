# frozen_string_literal: true

require "bundler/setup"
require "sinatra"
require "sinatra/reloader"
require "securerandom"
require "json"
require "pry"

class Memo
  def self.create(title: memo_title, body: memo_body)
    h = { id: SecureRandom.uuid, title: title, body: body }
    File.open("model/#{h[:id]}.json", "w") { |f| f.puts JSON.pretty_generate(h) }
  end
end

get "/" do
  files = Dir.glob("model/*")
  @memos = files.map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  erb :index
end

get "/memos/new" do
  erb :new
end

post "/memos/new" do
  Memo.create(title: params[:title], body: params[:body])
  redirect to("/")
end
