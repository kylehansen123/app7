require 'open-uri'
require 'json'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class FavoritesController < ApplicationController
  def index
    @favorites = Favorite.all
    @search = "1984"
    @author_id_search = "9721"
    @book_id_search = "544"

    # Github sosedoff
    @key = "ud9nX57jOGdQCwP2PyP5Ig"
    secret = "GQh5qIFlro973mZLQM6bJEnMvogN4WpxwAr24afcQ"
    client = Goodreads::Client.new(:api_key => @key, :api_secret => secret)

    @result = client.search_books(@search)
    @book = client.book_by_title(@search)


    # Nokogiri
    url_safe_address = URI.encode(@search)
    url_of_data_we_want = "https://www.goodreads.com/search.xml?key="+ @key + "&q=" + url_safe_address
    raw_data = open(url_of_data_we_want).read
    @parsed_data = Nokogiri::XML(raw_data)

    author_id_search = URI.encode(@author_id_search)
    url_of_author_id_search = "https://www.goodreads.com/author/show/" + author_id_search + ".xml?key=" + @key
    raw_author_id_data = open(url_of_author_id_search).read
    @parsed_author_id_data = Nokogiri::XML(raw_author_id_data)

    book_id_search = URI.encode(@book_id_search)
    url_of_book_id_search = "https://www.goodreads.com/book/show/" + book_id_search + "?format=xml&key=" + @key
    raw_book_id_data = open(url_of_book_id_search).read
    @parsed_book_id_data = Nokogiri::XML(raw_book_id_data)

    @search_results = @parsed_data.css("GoodreadsResponse/search/results/work/best_book")
    @author_id_results = @parsed_author_id_data.css("GoodreadsResponse")
    @book_id_results = @parsed_book_id_data.css("GoodreadsResponse")

  end

  def show
    @favorite = Favorite.find(params[:id])
    @search = "1984"
    @author_id_search = "9721"
    @book_id_search = "544"

    # Github sosedoff
    key = "ud9nX57jOGdQCwP2PyP5Ig"
    secret = "GQh5qIFlro973mZLQM6bJEnMvogN4WpxwAr24afcQ"
    client = Goodreads::Client.new(:api_key => key, :api_secret => secret)

    @result = client.search_books(@search)
    @book = client.book_by_title(@search)


    # Nokogiri
    url_safe_address = URI.encode(@search)
    url_of_data_we_want = "https://www.goodreads.com/search.xml?key="+ key + "&q=" + url_safe_address
    raw_data = open(url_of_data_we_want).read
    @parsed_data = Nokogiri::XML(raw_data)

    author_id_search = URI.encode(@author_id_search)
    url_of_author_id_search = "https://www.goodreads.com/author/show/" + author_id_search + ".xml?key=" + key
    raw_author_id_data = open(url_of_author_id_search).read
    @parsed_author_id_data = Nokogiri::XML(raw_author_id_data)

    book_id_search = URI.encode(@book_id_search)
    url_of_book_id_search = "https://www.goodreads.com/book/show/" + book_id_search + "?format=xml&key=" + key
    raw_book_id_data = open(url_of_book_id_search).read
    @parsed_book_id_data = Nokogiri::XML(raw_book_id_data)

    @search_results = @parsed_data.css("GoodreadsResponse/search/results/work/best_book")
    @author_id_results = @parsed_author_id_data.css("GoodreadsResponse")
    @book_id_results = @parsed_book_id_data.css("GoodreadsResponse")


  end

  def new
    @favorite = Favorite.new
  end

  def create
    @favorite = Favorite.new
    @favorite.user_id = params[:user_id]
    @favorite.goodreads_book_id = params[:goodreads_book_id]

    if @favorite.save
      redirect_to "/favorites", :notice => "Favorite created successfully."
    else
      render 'new'
    end
  end

  def edit
    @favorite = Favorite.find(params[:id])
  end

  def update
    @favorite = Favorite.find(params[:id])

    @favorite.user_id = params[:user_id]
    @favorite.goodreads_book_id = params[:goodreads_book_id]

    if @favorite.save
      redirect_to "/favorites", :notice => "Favorite updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])

    @favorite.destroy

    redirect_to "/favorites", :notice => "Favorite deleted."
  end
end
