# frozen_string_literal: true

require_relative '../actions/jira_format_action'

describe JiraFormatAction do
  before(:each) { @action = JiraFormatAction.new }

  describe 'execute' do
    it 'returns a failure message when the input is empty' do
      expect(@action.execute('')).to eq(@action.failure_message)
    end

    it 'returns an empty string when the url is nil' do
      expect(@action.execute(nil)).to eq(@action.failure_message)
    end

    it 'returns a formatted markdown link given a url with extra chars' do
      string = "https://jira.atlassian.net/browse/ALEX-2020\n"
      expected = '[ALEX-2020](https://jira.atlassian.net/browse/ALEX-2020)'
      expect(@action.execute(string)).to eq(expected)
    end
  end

  describe 'ticket_number_from_url' do
    it 'returns ALEX-2020 from the url' do
      url = 'https://jira.atlassian.net/browse/ALEX-2020'
      expect(@action.ticket_number_from_url(url)).to eq('ALEX-2020')
    end

    it 'returns nil if the url is invalid' do
      url = 'https://jira.atlassian.net/browse/ALEX-'
      expect(@action.ticket_number_from_url(url)).to be nil
    end
  end

  describe 'valid_jira_url' do
    it 'returns true when the url ends with the ticket number format' do
      url = 'https://jira.atlassian.net/browse/ALEX-2020'
      expect(@action.valid_jira_url?(url)).to be true
    end

    it 'returns false when the url does not end with ticket number format' do
      url = 'https://jira.atlassian.net/browse/'
      expect(@action.valid_jira_url?(url)).to be false
    end
  end

  describe 'markdown_url_from_url' do
    it 'returns empty string when the url is invalid' do
      string = 'https://jira.atlassian.net/browse/ALEX'
      expect(@action.markdown_url_from_url(string)).to eq('')
    end

    it 'returns a formatted markdown link given a url' do
      string = 'https://jira.atlassian.net/browse/ALEX-2020'
      expected = '[ALEX-2020](https://jira.atlassian.net/browse/ALEX-2020)'
      expect(@action.markdown_url_from_url(string)).to eq(expected)
    end
  end
end
