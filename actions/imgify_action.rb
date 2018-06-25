# frozen_string_literal: true

require 'pug'
require 'uri'

# An action that takes in image urls uploaded to Github
# and wraps them in <img> tags if they're not already.
class ImgifyAction < Pug::Interfaces::Action
  RESIZE_PERCENT = 60

  # Overrides
  def name
    'Format Github Upload Urls'
  end

  def description
    'Converts image urls to markdown'
  end

  def requires_input?
    true
  end

  def execute(input)
    # Check if there is at least one valid url in input
    return failure_message unless valid_github_upload_url?(input)
    # Split the inputs by new lines, parse, and then rejoin on new lines
    all_lines = input.split("\n")
    output = imgify_strings(all_lines)
    return empty_message if output.empty?
    output.join("\n")
  end

  # Helpers
  def failure_message
    'Sorry, I was unable to parse that input.'
  end

  def empty_message
    'Sorry, I was unable to produce any results from that input'
  end

  def image_tag_present?(string)
    string.start_with?('<img ')
  end

  def valid_github_upload_url?(string)
    url_from_github_upload_url(string)
  end

  # Returns url from upload url if it matches valid format
  def url_from_github_upload_url(string)
    match = string.match(/^!\[.*\]\((https:\/\/\S*)\)$/)
    match[1] unless match.nil?
  end

  def imgify_string(string)
    return string if image_tag_present?(string)
    return unless valid_github_upload_url?(string)
    match = url_from_github_upload_url(string)
    "<img src=\"#{match}\" width=#{RESIZE_PERCENT}% height=#{RESIZE_PERCENT}%>"
  end

  def imgify_strings(strings)
    output_strings = []
    strings.each do |string|
      output_string = imgify_string(string)
      output_strings.push(output_string) unless output_string.nil?
    end
    output_strings
  end
end
