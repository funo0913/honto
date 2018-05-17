class BooksController < ApplicationController
  require 'net/http'
  BASE_API_URL = "https://www.googleapis.com/books/v1/volumes".freeze
  UNREGISTERED = "未登録".freeze
  MAX_RESULTS = 20.freeze

  # 何もしない
  def index

  end

  #apiでの書籍検索
  def search_api
    @search_word = params[:book][:search_word]
    if @search_word.empty?
      redirect_to reviews_path, alert: '検索キーワードを入力してください'
      return
    end
    search_word = URI.encode_www_form({ q: params[:book][:search_word]})
    if Rails.application.secrets.use_api=='Google'
      @books = get_bookinfos_from_google(search_word)
    else
      #他のapiに対応できたら検討する
      @books = Book.new
    end
    render "books/index"
  end

  private

  #google books api 利用時
  #戻りはbookの配列
  def get_bookinfos_from_google(search_word)

    uri = URI.parse("#{BASE_API_URL}?#{search_word}&maxResults=#{MAX_RESULTS}&country=JP&printType=books")

    begin
      #httpセッションの開始
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        # Net::HTTP.open_timeout=で接続時に待つ最大秒数の設定をする
        http.open_timeout = 5
        # Net::HTTP#getでレスポンスの取得
        Net::HTTP.get_response(uri)
      end
      case response
        when Net::HTTPOK
          result = JSON.parse(response.body)
        else
          @logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
      end
    #例外処理 TBD
    rescue TimeoutError => e
      @logger.error(e.message)
      redirect_to reviews_path, alert: '情報の取得に失敗しました'
      return
    rescue => e
      @logger.error(e.message)
      redirect_to reviews_path, alert: '情報の取得に失敗しました'
      return
    end

    #google books apiで取得する
    books = []
    result['items'].each do |item|

      isbn = get_isbn_from_google(item)
      authors = get_authers_from_google(item)
      publication = get_publication_from_google(item)
      publisher = get_publisher_from_google(item)
      thumbnail = get_thumbnail_from_google(item)
      book = Book.new(
        isbn: isbn,
        title: item['volumeInfo']['title'],
        author: authors,
        publication: publication,
        publisher: publisher,
        thumbnail: thumbnail
      )
      books << book
    end
    debugger
    books.sort!{|a,b|b[:publication] <=> a[:publication]}

    @book = Book.new
    books
  end

  #ISBNの取得
  #ISBN_13を優先する
  #ISBNがない、またはISBN以外の情報（OTHERなど）のみの場合は未登録とする
  def get_isbn_from_google(item)
    isbn = ""
    if item['volumeInfo'].has_key?('industryIdentifiers')
      item['volumeInfo']['industryIdentifiers'].each do |identifier|
        if identifier['type']=='ISBN_13'
          isbn = identifier['identifier']
          break
        elsif identifier['type']=='ISBN_10'
          isbn = identifier['identifier']
          break
        else
          isbn = UNREGISTERED
        end
      end
    else
      isbn = UNREGISTERED
    end
    isbn
  end
  #出版社の取得
  #情報がない場合は未登録とする
  def get_publisher_from_google(item)
    publisher = item['volumeInfo'].has_key?('publisher') ? item['volumeInfo']['publisher'] : UNREGISTERED
  end
  def get_thumbnail_from_google(item)
    image = item['volumeInfo'].has_key?('imageLinks') ? item['volumeInfo']['imageLinks']['smallThumbnail'] : 'no_image.png'
  end
  #著者の取得
  def get_authers_from_google(item)
    authors = ""
    if !item['volumeInfo'].has_key?('authors')
      authors = UNREGISTERED
    elsif item['volumeInfo']['authors'].count > 1
      authors_array = []
      item['volumeInfo']['authors'].each do |author|
        authors_array << author.to_s
      end
      authors = authors_array.join(",")
    else
      authors = item['volumeInfo']['authors'][0]
    end
    authors
  end
  #出版日の取得
  def get_publication_from_google(item)
    if item['volumeInfo'].has_key?('publishedDate')
      if item['volumeInfo']['publishedDate'].length == 4
        item['volumeInfo']['publishedDate'] += '-01-01'
      elsif item['volumeInfo']['publishedDate'].length < 10
        item['volumeInfo']['publishedDate'] += '-01'
      end
      date = item['volumeInfo']['publishedDate'].to_datetime
    else
      date = nil
    end
    date
  end

  #TODO:amazonの書籍検索apiが使えたら検討する

end
