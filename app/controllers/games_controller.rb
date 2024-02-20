# require 'rest-client' not required as alr loaded into Gemfile
# require 'json' not required as alr loaded into Gemfile

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { [*'A'..'Z'].sample }
  end

  def score
    english_word = english_word?
    included = word_included?
    if english_word
      if included
        @message = "Congratulations! #{params[:word]} is a valid English word"
      else
        @message = "Sorry, #{params[:word]} can't be built out of #{params[:letters]}."
      end
    else
      @message = "Sorry, #{params[:word]} does not seem to be a valid English word..."
    end
  end

  private

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    response = RestClient.get url
    json = JSON.parse(response.body)
    json["found"]
  end

  def word_included?
    words_array = params[:word].upcase.chars
    letters_array = params[:letters].split
    words_array.all? { |word| words_array.count(word) <= letters_array.count(word) }
  end
end
