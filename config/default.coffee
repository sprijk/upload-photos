require('dotenv').config()

module.exports =
	crontab: "0 * * * * *"

	google:
		user: process.env.GOOGLE_USERNAME
		pass: process.env.GOOGLE_PASSWORD

	webcam:
		host: "c1.demannenvanrijk.nl"
		port: 88
		user: process.env.WEBCAM_USERNAME
		pass: process.env.WEBCAM_PASSWORD

	picture:
		path: "/tmp/pics"
