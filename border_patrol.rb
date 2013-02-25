# script to get video position based on system time
# return this time, so fcgi can give it to the user

# similarly, return a string representing a .m3u8 file 
# on the fly to point to proper .ts files 
# (mobile / safari support)


START_POINT = 0
TOTAL_SECONDS = 43200 #12 * 60 * 60
HLS_FOLDER = "bp480-hls-lq/"
HLS_FILE_PREFIX = "bp480-hls-lq"

def get_end secs
	end_secs = secs + 3600
	if end_secs > TOTAL_SECONDS 
		end_secs = TOTAL_SECONDS
	end
	return end_secs
end	

def get_secs
	ltime = Time.now.getlocal
	secs = 0
	# convert from 24-hr time to 12hr
	hours = ltime.hour
	if( hours > 12 ) 
		hours-=12 
	end

	secs += hours * 3600
	secs += ltime.min * 60
	secs += ltime.sec
	return secs
end


def write_m3u8_header(lines)
	lines.concat [
	"#EXTM3U",
	"#EXT-X-VERSION:3",
	"#EXT-X-MEDIA-SEQUENCE:0",
	"#EXT-X-ALLOWCACHE:1",
	"#EXT-X-TARGETDURATION:10"]
end

def get_playlist
	lines = []
	clip_num = ( get_secs() / 10 ).floor
	write_m3u8_header( lines );

# provide a buffer 10 clips ahead
# for some reason each clip has a EXTINF:8 or 12 prefix
# and it alternates every time... not asking questions.
	#
	(0..10).each { |pos|
		if(pos%2 == 0 ) then
			lines << "#EXTINF:12.000000," 
		else
			lines << "#EXTINF:8.000000," 
		end
# start a few frames behind to maintain continuity in list
	num = (clip_num + pos - 2)
		lines << "#{HLS_FOLDER}#{HLS_FILE_PREFIX}%04d.ts" % num 
	}

	playlist = ""
# I don't know why this is necessary, but it works!!
	f = File.new("playlist-lq-temp.m3u8", "w")
		lines.each { |l|
			f << l
			f << "\n"
		}
	f.close
	
end

