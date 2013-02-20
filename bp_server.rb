require 'rubygems'
require 'sinatra'
require 'border_patrol'

configure do
	mime_type :text, 'text/plain'
	mime_type :m3u8, 'application/x-mpegURL or vnd.apple.mpegURL'
	mime_type :ts, 	 'video/MP2T'
end

get '/', :agent => /(iPhone|iPod|iPad|Android)/ do
		erb :viewer, :locals => {:supports_hls => true};
end

get '/' do
		erb :viewer, :locals => {:supports_hls => false};
end

get '/time' do
	"#{get_secs}"
end

get '/playlist-lq.m3u8' do
	content_type :m3u8
	get_playlist
end

get '/media/bp480-hls-lq/:segment' do
	send_file "media/bp480-hls-lq/#{params[:segment]}", :type => :ts
end



