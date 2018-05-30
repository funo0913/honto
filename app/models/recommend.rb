class Recommend < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # お勧めの更新(ステータスを既読にして更新したタイミングで呼び出し)
  def self.update_recommend(cur_user_id)
    #該当ユーザの最新の既読ステータス書籍を3件取得
    readed_book_ids = Review.where(user_id: cur_user_id)
                            .where(status: 3)
                            .order(:updated_at)
                            .limit(10).pluck(:book_id)
    #同じ書籍に感想を登録している別ユーザのIDを取得
    other_users = Review.where.not(user_id: cur_user_id)
                        .where(book_id: readed_book_ids)
                        .group(:user_id).count
    if other_users.nil?
      #似たような人がいなければ戻る
      return
    end
    mine_books = Review.where(user_id: cur_user_id).pluck(:book_id)
    recommend_book_ids = []
    other_users.each do |user|
      if user[1] >= 3
        books_id = Review.where.not(book_id: mine_books).where(user_id: user[0]).limit(1)
        if !books_id.length == 0
            recommend_book_ids << books_id[0].book_id
        end
      end
      if recommend_book_ids.length > 20
        break
      end
    end
    #既存の登録情報を削除する
    User.find(cur_user_id).recommends.destroy_all
    recommend_book_ids.each do |book|
      recommend = Recommend.new
      recommend.user_id = cur_user_id
      recommend.book_id = book
      recommend.save
    end
    #該当の別ユーザの感想の中で、cur_userが本棚に入れていない書籍を取得する
  end
end
