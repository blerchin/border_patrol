require 'rubygems'
require 'sinatra'
require 'border_patrol'

last_playlist_update = Time.now.to_i

configure do
	mime_type :text, 'text/plain'
	mime_type :m3u8, 'application/x-mpegURL'
	mime_type :ts, 	 'video/MP2T'
	get_playlist
	last_playlist_update = Time.now.to_i
end

get '/', :agent => /(iPhone|iPod|iPad)/ do
		erb :viewer, :locals => {:supports_hls => true};
end

get '/' do
		erb :viewer, :locals => {:supports_hls => false};
end

get '/time' do
	"#{get_secs}"
end

get '/media/playlist-lq.m3u8' do
	if (Time.now.to_i - last_playlist_update) > 1 then 
		get_playlist
		last_playlist_update = Time.now.to_i
	end
	send_file "playlist-lq-temp.m3u8", :type => :m3u8
end




