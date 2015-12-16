#!/usr/bin/env ruby
require 'watir-webdriver'
browser = Watir::Browser.new :firefox
browser.window.resize_to(1280, 1024)
browser.goto ARGV[0]
browser.screenshot.save ARGV[0]+'.png'
browser.close
`convert #{ARGV[0]+'.png'} -crop 1240x900+0+0 #{ARGV[0]+'.png'}`
`convert #{ARGV[0]+'.png'} -resize 20% #{ARGV[0]+'.png'}`
