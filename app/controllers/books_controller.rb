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
    if params[:book][:search_word].nil? || params[:book][:search_word].empty?
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

    uri = URI.parse("#{BASE_API_URL}?#{search_word}&maxResults=#{MAX_RESULTS}")

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
      publisher = get_publisher_from_google(item)
      book = Book.new(
        isbn: isbn,
        title: item['volumeInfo']['title'],
        author: item['volumeInfo']['authors'],
        publication: item['volumeInfo']['publishedDate'],
        publisher: publisher
      )
      books << book
    end
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

  #TODO:amazonの書籍検索apiが使えたら検討する

end
