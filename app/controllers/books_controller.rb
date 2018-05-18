class BooksController < ApplicationController
  require 'net/http'
  BASE_API_URL = "https://www.googleapis.com/books/v1/volumes".freeze
  UNREGISTERED = "未登録".freeze
  MAX_RESULTS = 40.freeze

  # 何もしない?
  def index
  end

  #apiでの書籍検索
  def search
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
    @books = Kaminari.paginate_array(@books).page(params[:page]).per(10)
  end

  def edit
    # 読書感想の有無を判定する
    target_book = Book.find_by(tmp_id: params[:tmp_id])
    @is_reviewed = false
    if !target_book.nil?
      @is_reviewed = Review.exists?(book_id: target_book.id)
    end
    uri = URI.parse("#{BASE_API_URL}?q=id:#{params[:tmp_id]}")
    result = get_bookinfo_from_google_core(uri)

    @book_description = result['items'][0]['volumeInfo'].has_key?('description')? result['items'][0]['volumeInfo']['description'] : UNREGISTERED
    @book = Book.new(
      isbn: params[:isbn],
      title: params[:title],
      author: params[:author],
      publication: params[:publication],
      publisher: params[:publisher]
    )
  end

  private
  def books_params
    params.require(:book).permit(:title,:tmp_id)
  end


  #google books api 利用時
  #戻りはbookの配列
  #:TODO 作者検索は関連性の高いものを絞っているが、作品名検索などをした場合関連性の低いものも該当してしまう
  #      出版日の書式が不統一・無いものも存在するためかソートに失敗する場合がある
  #      できれば捨てたい
  def get_bookinfos_from_google(search_word)

    uri = URI.parse("#{BASE_API_URL}?#{search_word}&maxResults=#{MAX_RESULTS}&printType=books")
    result = get_bookinfo_from_google_core(uri)

    #google books apiで取得する
    books = []
    result['items'].each do |item|
      book = Book.new(
        isbn: get_isbn_from_google(item),
        title: item['volumeInfo']['title'],
        author: get_authers_from_google(item),
        publication: get_publication_from_google(item),
        publisher: get_publisher_from_google(item),
        thumbnail: get_thumbnail_from_google(item),
        tmp_id: item['id']
      )
      books << book
    end
    begin
      books.sort!{|a,b|b[:publication] <=> a[:publication]}
    rescue
      # 例外が起きたら並び替えを諦める…:TODO
    end
    @book = Book.new
    return books
  end

  def get_bookinfo_from_google_core(uri)
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
      redirect_to reviews_path, alert: '情報の取得に失敗しました'
      return
    rescue => e
      redirect_to reviews_path, alert: '情報の取得に失敗しました'
      return
    end
    return result
  end

  #------------------------------------
  # googlebooksapiができてないところの補助…
  #------------------------------------

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
    # publishDateがなければnil
    date = nil
    if item['volumeInfo'].has_key?('publishedDate')
      datestr = item['volumeInfo']['publishedDate']
      begin
        date = Datetime.parse(datestr).to_s
      rescue
        formats = ['%Y-%m-%d','%Y-%m','%Y']
        formats.each do |format|
          begin
            date = DateTime.strptime(datestr, format)
            break
          rescue
          end
        end
      end
    end
   date
  end

  #TODO:amazonの書籍検索apiが使えたら検討する

end
