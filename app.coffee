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
  console.log subject
  console.log message
  console.log '\n'
  #mailer.send subject, message, console.log

setInterval ebk.scrape, config.scrapInterval * 60 * 1000

console.log "service is up and runing first scraping action starts in #{config.scrapInterval * 60} seconds"
