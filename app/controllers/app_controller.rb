class AppController < ApplicationController
  def search

    @search = params["new_search"]

    # Github sosedoff
    @key = "ud9nX57jOGdQCwP2PyP5Ig"
    secret = "GQh5qIFlro973mZLQM6bJEnMvogN4WpxwAr24afcQ"
    client = Goodreads::Client.new(:api_key => @key, :api_secret => secret)

    @result = client.search_books(@search)
    @book = client.book_by_title(@search)

  end
end
