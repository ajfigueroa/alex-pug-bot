# frozen_string_literal: true

require_relative '../actions/imgify_action'

describe ImgifyAction do
  before(:each) { @action = ImgifyAction.new }

  describe 'execute' do
    it 'handles a single line input' do
      string = '![test screenshot](https://test/test.png)'
      expected = '<img src="https://test/test.png" width=60% height=60%>'
      expect(@action.execute(string)).to eq(expected)
    end

    it 'handles a multi line input' do
      string = "![test screenshot](https://test/test1.png)\n" \
              "![test screenshot](https://test/test2.png)\n" \
              '![test screenshot](https://test/test3.png)'
      expected = "<img src=\"https://test/test1.png\" width=60% height=60%>\n" \
                "<img src=\"https://test/test2.png\" width=60% height=60%>\n" \
                '<img src="https://test/test3.png" width=60% height=60%>'
      expect(@action.execute(string)).to eq(expected)
    end

    it 'shows a failure message for invalid inputs' do
      string = 'https://user-images.youtube.com/test1.png'
      expect(@action.execute(string)).to eq(@action.failure_message)
    end

    it 'handles a single invalid input' do
      string = "![test screenshot](https://test/test1.png)\n" \
              "![test screenshot](https://test/test2.png)\n" \
              'https://user-images.youtube.com/test1.png'
      expected = "<img src=\"https://test/test1.png\" width=60% height=60%>\n" \
                '<img src="https://test/test2.png" width=60% height=60%>'
      expect(@action.execute(string)).to eq(expected)
    end
  end

  describe 'image_tag_present?' do
    it 'returns true when it does have an <img> tag' do
      string = '<img width="1440" alt="test" src="https://test/test.png">'
      expect(@action.image_tag_present?(string)).to be true
    end

    it 'returns false when it does NOT have an <img> tag' do
      string = '![test screenshot](https://test/test.png)'
      expect(@action.image_tag_present?(string)).to be false
    end
  end

  describe 'valid_github_upload_url?' do
    it 'returns true if it is a valid string' do
      string = '![test screenshot](https://test/test.png)'
      expect(@action.valid_github_upload_url?(string)).to be_truthy
    end

    it 'returns false if it is NOT a valid string' do
      string = 'https://test/test.png'
      expect(@action.valid_github_upload_url?(string)).to be_falsy
    end
  end

  describe 'url_from_github_upload_url' do
    it 'returns the url if it is a valid string' do
      string = '![test screenshot](https://test/test.png)'
      expected = 'https://test/test.png'
      expect(@action.url_from_github_upload_url(string)).to eq(expected)
    end

    it 'returns nil if it is NOT a valid string' do
      string = 'https://test/test.png'
      expect(@action.url_from_github_upload_url(string)).to be nil
    end
  end

  describe 'imgify_string' do
    it 'returns itself if it already has an <img> tag' do
      string = '<img width="1440" alt="test" src="https://test/test.png">'
      expect(@action.imgify_string(string)).to eq(string)
    end

    it 'returns nil if it is NOT a valid github upload url' do
      string = 'https://test/test.png'
      expect(@action.imgify_string(string)).to be nil
    end

    it 'returns the an imgified string if it is a valid github upload url' do
      string = '![test screenshot](https://test/test.png)'
      expected = '<img src="https://test/test.png" width=60% height=60%>'
      expect(@action.imgify_string(string)).to eq(expected)
    end
  end

  describe 'imgify_strings' do
    it 'returns an empty array if all the strings are invalid' do
      strings = ['https://test.com', 'https://test2.com', 'https://test3.com']
      expect(@action.imgify_strings(strings)).to be_empty
    end

    it 'returns a single item if only one string is valid' do
      string = '![test screenshot](https://test/test.png)'
      strings = ['https://test.com', string, 'https://test3.com']
      expect(@action.imgify_strings(strings).count).to eq(1)
    end

    it 'returns a all valid items if valid' do
      string1 = '![test screenshot](https://test/test.png)'
      string2 = '<img width="1440" alt="test" src="https://test/test.png">'
      strings = ['https://test.com', string1, string2]
      expect(@action.imgify_strings(strings).count).to eq(2)
    end
  end
end
