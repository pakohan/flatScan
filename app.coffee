EbkScraper = require './ebkScraper'
Mailer = require './mailer'

config = require './config/berlin.json'

ebk = new EbkScraper config.scrapingOpts
mailer = new Mailer config.mail

sendIds = []

ebk.on 'match', (offer) ->
  return if offer.id in sendIds
  subject = "#{offer.district} -> #{offer.rooms} Zi -> #{offer.size} qm -> #{offer.netRent} Eur"
  message = "#{offer.href}\n\n#{offer.phone}"

  sendIds.push offer.id
  mailer.send subject, message, console.log

setInterval ebk.scrape, config.scrapInterval * 1 * 1000

console.log "service is up and runing\nfirst scraping action starts in #{config.scrapInterval * 60} seconds"
