json.extract! review, :id, :user_id, :book_id :status_id, :title, :innocent_review, :review, :private, :warning, :created_at, :updated_at
json.url review_url(review, format: :json)
