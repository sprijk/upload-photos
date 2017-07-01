async   = require "async"
config  = require "config"
debug   = (require "debug") "app"
fs      = require "fs"
GPhotos = require "upload-gphotos"
mkdirp  = require "mkdirp"
moment  = require "moment"
path    = require "path"
request = require "request"
rimraf  = require "rimraf"

date        = moment().format "YYYY-MM-DD HH:mm:ss"
picFilePath = path.resolve config.picture.path, "./#{date}.jpg"

getUrl = ->
	url  = "http://"
	url += config.webcam.host
	url += ":#{config.webcam.port}" if config.webcam.port
	url += "/cgi-bin/CGIProxy.fcgi?cmd=snapPicture2"
	url += "&amp;usr=#{config.webcam.user}" if config.webcam.user
	url += "&amp;pwd=#{config.webcam.pass}" if config.webcam.user and config.webcam.pass
	debug "URL is:", url
	url

takePic = (cb) ->
	debug "Getting pic from foscam"
	request getUrl()
		.pipe fs.createWriteStream picFilePath
		.once "finish", cb

upoadPic = (cb) ->
	debug "Upload to Google Photos"

	gphotos = new GPhotos
		username: config.google.user
		password: config.google.pass

	photo = null
	album = null

	arr = [
		(cb) ->
			gphotos.login()
				.catch (error) -> cb error
				.then ->
					debug "Logged in"
					cb()

		(cb) ->
			(gphotos.upload picFilePath)
				.catch (error) -> cb error
				.then (p) ->
					debug "Uploaded photo"
					photo = p
					cb()

		(cb) ->
			(gphotos.searchOrCreateAlbum "FoscamC1")
				.catch (error) -> cb error
				.then (a) ->
					debug "Got album"
					album = a
					cb()

		(cb) ->
			(album.addPhoto photo)
				.catch (error) -> cb error
				.then ->
					debug "Added photo to album"
					cb()
	]

	async.series arr, cb

console.log "Starting..."

async.series [
	(cb) -> rimraf config.picture.path, cb
	(cb) -> mkdirp config.picture.path, cb
	(cb) -> takePic cb
	(cb) -> upoadPic cb
], (error) ->
	throw error if error
	console.log "Finished"
