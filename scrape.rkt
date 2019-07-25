#! /usr/bin/env racket

#lang racket

(require file/untgz net/url)
(require sxml)
(require scrapyard)

(define package-listing-page-url (string->url "http://snow-fort.org/pkg"))

(define (list-tgz-urls)
  (map (λ (link-url) (combine-url/relative package-listing-page-url link-url))
       (filter
        (λ (url) (string-suffix? url ".tgz"))
        ((sxpath "//a/@href/text()")
         (scrape-html (cache-http "pkg.html" package-listing-page-url))))))

(define (url-basename url)
  (path/param-path (last (url-path url))))

(define (download-tgz-url url)
  (cache-http (url-basename url) url))

(for-each download-tgz-url (list-tgz-urls))
