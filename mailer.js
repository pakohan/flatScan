// Generated by CoffeeScript 1.6.3
(function() {
  var Mailer, emailer, exports;

  emailer = require("nodemailer");

  Mailer = (function() {
    function Mailer(opts) {
      this.opts = opts;
    }

    Mailer.prototype.send = function(subject, message, cb) {
      var messageData, transport;
      messageData = {
        to: this.opts.mailto,
        from: "Me",
        subject: subject,
        html: message,
        generateTextFromHTML: false
      };
      transport = this.getTransport();
      return transport.sendMail(messageData, cb);
    };

    Mailer.prototype.getTransport = function() {
      return emailer.createTransport("SMTP", {
        service: "Gmail",
        auth: {
          user: this.opts.sender.user,
          pass: this.opts.sender.pass
        }
      });
    };

    return Mailer;

  })();

  exports = module.exports = Mailer;

}).call(this);