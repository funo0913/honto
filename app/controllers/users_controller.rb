class UsersController < ApplicationController
  before_action :authenticate_user!,onry: [:show]
    # 残っているメッセージは削除する
    if flash[:alert].present?
      flash.delete(:alert)
    end
    # topページ表示時にセッション情報をすべて破棄する
    reset_session

    # LPの表示
    render layout: false
  end
  def show
    @user = User.find(current_user.id)
    @search_book = Book.new
  end

end
