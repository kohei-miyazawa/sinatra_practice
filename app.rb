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

  def self.find(id: memo_id)
    JSON.parse(File.read("model/#{id}.json"), symbolize_names: true)
  end

  def self.update(id: memo_id, title: memo_title, body: memo_body)
    h = { id: id, title: title, body: body }
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

get "/memos/:id" do
  @memo = Memo.find(id: params[:id])
  erb :show
end

get "/memos/edit/:id" do
  @memo = Memo.find(id: params[:id])
  erb :edit
end

patch "/memos/:id" do
  Memo.update(id: params[:id], title: params[:title], body: params[:body])
  redirect to("/memos/#{params[:id]}")
end
