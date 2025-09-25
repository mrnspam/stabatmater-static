#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'yaml'

begin
  require 'nokogiri'
rescue LoadError
  warn 'nokogiri is required. Run `bundle install` to install dependencies.'
  exit 1
end

options = {
  layout: 'default'
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: bundle exec ruby script/migrate_page.rb legacy/index.html [output]"

  opts.on('--layout=LAYOUT', 'Layout to use in front matter (default: default)') do |value|
    options[:layout] = value
  end

  opts.on('--[no-]keep-entry-header', 'Keep the legacy entry header (default: false)') do |value|
    options[:keep_entry_header] = value
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end

parser.parse!

if ARGV.empty?
  warn parser
  exit 1
end

input_path = ARGV[0]
output_path = ARGV[1] || input_path

unless File.exist?(input_path)
  warn "Input file not found: #{input_path}"
  exit 1
end

html = File.read(input_path)
document = Nokogiri::HTML.parse(html)

front_matter = {}
front_matter['layout'] = options[:layout]

page_title = document.at_css('h1.entry-title')&.text&.strip
front_matter['title'] = page_title unless page_title.nil? || page_title.empty?

seo_title = document.at_css('head > title')&.text&.strip
front_matter['seo_title'] = seo_title unless seo_title.nil? || seo_title.empty?

description = document.at_css('meta[name="description"]')&.[]('content')&.strip
front_matter['description'] = description unless description.nil? || description.empty?

canonical = document.at_css('link[rel="canonical"]')&.[]('href')&.strip
front_matter['canonical'] = canonical unless canonical.nil? || canonical.empty?

lang = document.at_css('html')&.[]('lang')&.strip
front_matter['lang'] = lang unless lang.nil? || lang.empty?

robots = document.at_css('meta[name="robots"]')&.[]('content')&.strip
front_matter['robots'] = robots unless robots.nil? || robots.empty?

og_type = document.at_css('meta[property="og:type"]')&.[]('content')&.strip
front_matter['og_type'] = og_type unless og_type.nil? || og_type.empty?

last_modified = document.at_css('meta[property="article:modified_time"], meta[property="og:updated_time"]')&.[]('content')&.strip
front_matter['last_modified_at'] = last_modified unless last_modified.nil? || last_modified.empty?

body_class = document.at_css('body')&.[]('class')&.strip
front_matter['body_class'] = body_class unless body_class.nil? || body_class.empty?

entry_header = document.at_css('main#genesis-content > article > header.entry-header')
entry_header&.remove unless options[:keep_entry_header]

content_node = document.at_css('main#genesis-content') || document.at_css('article.entry, article')

unless content_node
  warn 'Could not locate the main content area (main#genesis-content or article).'
  exit 1
end

content_html = content_node.inner_html.strip

if content_html.empty?
  warn 'Extracted content is empty after stripping. Aborting to avoid data loss.'
  exit 1
end

def format_value(value)
  escaped = value.gsub('"', '\\"')
  "\"#{escaped}\""
end

File.open(output_path, 'w') do |file|
  file.puts('---')
  front_matter.each do |key, value|
    next if value.nil? || (value.respond_to?(:empty?) && value.empty?)

    file.puts("#{key}: #{format_value(value)}")
  end
  file.puts('---')
  file.puts
  file.puts(content_html)
  file.puts
end

puts "Converted #{input_path} -> #{output_path}"
