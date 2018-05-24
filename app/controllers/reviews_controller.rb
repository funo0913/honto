class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # 感想の新着一覧表示(最新２０件)
  def index
    @reviews = Review.all
    @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(10)
    @search_book = Book.new
  end

  # 自分の本棚の一覧表示
  def index_my_bookshelf
    @reviews = Review.where(user_id: current_user.id).page(params[:page]).per(10)
    @search_book = Book.new
  end

  # 感想の詳細表示
  def show
    @review = Review.find(params[:id])
    @search_book = Book.new
    @statuses = Status.all
  end

  # 使わないかもしれない
  def new
    @review = Review.new
  end

  # 感想の編集・更新
  def edit
    if @isAdded
      flash[:isAdded] = '登録済みです'
    end
    @search_book = Book.new
    @review = Review.find(params[:id])
    @book = Book.find(@review.book_id)
    @statuses = Status.all
  end


  # 本を本棚に追加する
  # bookに情報がなければBookを新規登録する
  def add_bookshelf
    #同様の書籍がすでに本棚にある場合は登録しない
    review = Review.find_by(user_id: current_user.id, book_id: params[:id])
    if review.nil?
      review = Review.new(
        user_id: current_user.id,
        book_id: params[:id],
        status_id: 1,
        title: '',
        innocent_review: '',
        review: ''
      )
      review.save
    end
    redirect_to action: :edit,id: review.id
  end

  # 感想の編集・更新
  def update
      if @review.update(review_params)
        redirect_to @review, notice: '感想を更新しました'
      else
        render :edit
      end
  end

  # 感想の破棄
  def destroy
    @review.destroy
    redirect_to reviews_url, notice: '本棚から削除しました'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:user_id,
                                     :book_id,
                                     :status_id,
                                     :title,
                                     :innocent_review,
                                     :review,
                                     :private,
                                     :warning
                                   )
    end
end
