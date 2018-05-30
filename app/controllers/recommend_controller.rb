class RecommendController < ApplicationController
  before_action :authenticate_user!

  def index
    @recommends = Recommend.where(user_id: current_user.id)
    @search_book = Book.new
  end
  def show
    # 読書感想の有無を判定する
    @recommend = Book.hash_inititalize(params)
  end
  private
  def recommend_params
    params.require(:recommend).permit(:book_id)
  end

end
