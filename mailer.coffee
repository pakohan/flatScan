emailer = require("nodemailer")

class Mailer
  constructor: (@opts)->

  send: (subject, message, cb)->
    messageData =
      to: @opts.mailto
      from: "Me"
      subject: subject
      html: message
      generateTextFromHTML: false
    transport = @getTransport()
    transport.sendMail messageData, cb

  getTransport: ()->
    emailer.createTransport "SMTP",
      service: "Gmail"
      auth:
        user: @opts.sender.user
        pass: @opts.sender.pass

exports = module.exports = Mailer
