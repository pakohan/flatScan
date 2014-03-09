cheerio = require 'cheerio'
request = require 'request'

baseUrl = "http://kleinanzeigen.ebay.de"

class EbkScraper extends require('events').EventEmitter
  constructor: (@opts) ->

  scrape: () =>
    self = @

    request.get baseUrl + @opts.targetUrl, self._loadOffer

  _loadOffer: (err, header, body) =>
    self = @

    console.error err if err
    $ = cheerio.load body

    $('#srchrslt-adtable > li').each ->
      self._extOffer
        titel: $(this).find('.ad-title').html()
        insertTime: $(this).find('.ad-listitem-addon').html().toString().replace(/\s/g, "")
        district: $(this).find('.c-h-adtble-lctn').html()[9..-1]
        postcode: $(this).find('.c-h-adtble-lctn').html()[0..4]
        netRent:  $(this).find('.ad-listitem-details > strong').html().replace(/\./g, "").match(/\d*/)[0]
        href: baseUrl + $(this).find('.ad-title')['0'].attribs.href
        subtitle: $(this).find('p').html()
      , (offer) ->
        self._checkOffer offer

  _extOffer: (offer, cb) ->
    request.get offer.href, (err, header, body) ->
      console.error err if err

      $ = cheerio.load body

      offer.street = $('#street-address').text()
      offer.insertDate = $($('.c-attrlist > dd')[1]).text()
      offer.id = $($('.c-attrlist > dd')[2]).text()
      offer.rooms = $($('.c-attrlist > dd')[3]).find('span').text().replace(/\s/g, "")
      offer.size = $($('.c-attrlist > dd')[4]).find('span').text().replace(/\s/g, "")
      offer.description =  $('p[itemprop="description"]').text()
      offer.phone = $($('.viewad-contact-phone')[0]).text()

      cb offer

  _checkOffer: (offer) ->
    # console.log "district: #{offer.district}; rent: #{offer.netRent}; rooms: #{offer.rooms}; size: #{offer.size}"
    return unless offer.district in @opts.district or offer.postcode in @opts.postcode
    return if offer.netRent < @opts.netRent.min or offer.netRent > @opts.netRent.max
    return if offer.rooms < @opts.rooms.min or offer.rooms > @opts.rooms.max
    return if offer.size < @opts.size.min or offer.size > @opts.size.max
    return if @opts.regex and not offer.description.match @opts.regex

    @emit 'match', offer

module.exports = EbkScraper
