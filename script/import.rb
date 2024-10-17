#!/usr/bin/env ruby

require_relative "../config/environment"

FeedsConfigurator.new.import

# TBD: Use params to define actual feeds scope
feeds = Feed.enabled.limit(1)

FeedProcessor.new(feeds: feeds).perform
