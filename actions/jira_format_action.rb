# frozen_string_literal: true

require 'pug'

# Takes a JIRA url and creates a markdown link
class JiraFormatAction < Pug::Interfaces::Action
  # Overrides
  def name
    'JIRA Url Format'
  end

  def requires_input?
    true
  end

  def execute(input)
    return failure_message unless valid_jira_url?(input)
    # Split the inputs by new lines, parse, and then rejoin on new lines
    output = markdown_url_from_url(input.strip)
    return empty_message if output.empty?
    output
  end

  # Helpers
  def valid_jira_url?(string)
    return false if string.nil?
    !ticket_number_from_url(string).nil?
  end

  # Returns url from jira url contains the ticket number
  def ticket_number_from_url(string)
    match = string.match(/^https:\/\/\S+\/(\w+-\d+)$/)
    match[1] unless match.nil?
  end

  def markdown_url_from_url(url)
    return '' unless valid_jira_url?(url)
    ticket_number = ticket_number_from_url(url)
    "[#{ticket_number}](#{url})"
  end

  def failure_message
    'I was unable to parse that input. Did you enter the correct format?'
  end

  def empty_message
    'I was unable to produce any results from that input.'
  end
end
