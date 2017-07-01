path    = require "path"
GPhotos = require "upload-gphotos"

# filePath = path.resolve __dirname, "../meta/test.jpg"
filePath = "/tmp/test.jpg"
gphotos  = null
photo    = null
album    = null

describe "Upload photo", ->
	before ->
		gphotos = new GPhotos
			username: process.env.GOOGLE_USERNAME
			password: process.env.GOOGLE_PASSWORD

	it "should login", (done) ->
		@timeout 10000

		gphotos.login()
			.then          -> done()
			.catch (error) -> throw error

		true

	it "should upload a photo", (done) ->
		@timeout 10000

		gphotos.upload filePath
			.then (p) ->
				photo = p
				done()
			.catch (error) -> throw error

		true

	it "should get or create an album", (done) ->
		@timeout 10000

		gphotos.searchOrCreateAlbum "TestAlbum"
			.then (a) ->
				album = a
				done()
			.catch (error) -> throw error

		true


	it "add the photo to the album", (done) ->
		@timeout 10000

		album.addPhoto photo
			.then          -> done()
			.catch (error) -> throw error

		true
