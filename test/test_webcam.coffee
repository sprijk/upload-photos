fs      = require "fs"
request = require "request"
http    = require "http"

webcam =
	host: "c1.demannenvanrijk.nl"
	# host: "192.168.1.86"
	port: 88
	user: process.env.WEBCAM_USERNAME
	pass: process.env.WEBCAM_PASSWORD

picture =
	filePath: "/tmp"

getUrl = ->
		url  = "http://"
		url += webcam.host
		url += ":#{webcam.port}" if webcam.port
		url += "/cgi-bin/CGIProxy.fcgi?cmd=snapPicture2"
		url += "&amp;usr=#{webcam.user}" if webcam.user
		url += "&amp;pwd=#{webcam.pass}" if webcam.user and webcam.pass
		console.log url
		url

describe "Take picture", ->
	it "should save the picture", (done) ->
		@timeout 10000

		request getUrl()
			.pipe fs.createWriteStream "/tmp/test.jpg"
			.once "finish", ->
				done()


		# path  = "/cgi-bin/CGIProxy.fcgi?cmd=snapPicture2"
		# path += "&amp;usr=#{webcam.user}" if webcam.user
		# path += "&amp;pwd=#{webcam.pass}" if webcam.user and webcam.pass

		# options =
		# 	host:   webcam.host
		# 	port:   webcam.port
		# 	path:   path
		# 	method: "GET"

		# console.log options

		# req = http.request options, (res) ->

		# 	data = ""
		# 	res.setEncoding "binary"

		# 	res.on "data", (chunk) -> data += chunk
		# 	res.on "end", ->
		# 		console.log data
		# 		done()

		# req.on "error", (error) -> throw error

		# req.end()
