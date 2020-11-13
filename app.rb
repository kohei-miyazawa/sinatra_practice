# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

# Memo class
class Memo
  CONNECT = PG.connect(host: 'localhost', user: 'postgres', password: 'postgres', dbname: 'sinatra_practice')

  class << self
    def all
      CONNECT.exec('SELECT * FROM memos')
    end

    def create(title: memo_title, body: memo_body)
      CONNECT.exec("INSERT INTO memos (title, body) VALUES ('#{title}', '#{body}')")
    end

    def find(id: memo_id)
      CONNECT.exec("SELECT * FROM memos WHERE id = '#{id}'")
    end

    def update(id: memo_id, title: memo_title, body: memo_body)
      CONNECT.exec("UPDATE memos SET title = '#{title}', body = '#{body}' WHERE id = '#{id}'")
    end

    def destroy(id: memo_id)
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
  Memo.create(title: params[:title], body: params[:body])
  redirect to('/')
end

get '/memos/:id' do
  @memo = Memo.find(id: params[:id])
  erb :show
end

get '/memos/edit/:id' do
  @memo = Memo.find(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.update(id: params[:id], title: params[:title], body: params[:body])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  Memo.destroy(id: params[:id])
  redirect to('/')
end
