class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # 感想の新着一覧表示
  def index
    @reviews = Review.all
    @book = Book.new
  end

  # 感想の詳細表示
  def show
    @book = Book.new
  end

  # 使わないかもしれない
  def new
    @review = Review.new
  end

  # 感想の編集・更新
  def edit
  end

  # 本を本棚に追加する
  #bookに情報がなければBookを新規登録する
  def add_bookshelf
    debugger
    review = Review.new(
      user_id: current_user.id,
      book_id: params[:id],
      status_id: 1,
      title: '',
      innocent_review: '',
      review: ''
    )
    review.save
    redirect_to action: :show,id: review.id

  end

  # 感想の編集・更新
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # 感想の破棄
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
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
