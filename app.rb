# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require 'dotenv/load'

# Memo class
class Memo
  CONNECT = PG.connect(host: ENV['DATABASE_HOST'], user: ENV['DATABASE_USER'], password: ENV['DATABASE_PASSWORD'], dbname: ENV['DATABASE_NAME'])

  class << self
    def all
      CONNECT.exec('SELECT * FROM memos')
    end

    def create(title, body)
      CONNECT.exec("INSERT INTO memos (title, body) VALUES ('#{title}', '#{body}')")
    end

    def find(id)
      CONNECT.exec("SELECT * FROM memos WHERE id = '#{id}'").first
    end

    def update(id, title, body)
      CONNECT.exec("UPDATE memos SET title = '#{title}', body = '#{body}' WHERE id = '#{id}'")
    end

    def destroy(id)
      CONNECT.exec("DELETE FROM memos WHERE id = #{id}")
    end
  end
end

helpers do
  def h(str)
    Rack::Utils.escape_html(str)
  end
end

get '/' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos/new' do
  Memo.create(params[:title], params[:body])
  redirect to('/')
end

get '/memos/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

get '/memos/edit/:id' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.update(params[:id], params[:title], params[:body])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  Memo.destroy(params[:id])
  redirect to('/')
end
