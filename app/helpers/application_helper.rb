module ApplicationHelper
  def devise_error_messages
    return "" if resource.errors.empty?
    html = ""
    # エラーメッセージ用のHTMLを生成
    messages = resource.errors.full_messages.each do |msg|
      html += <<-EOF
        <div class="alert" role="alert">
          <p class="error_msg">#{msg}</p>
        </div>
      EOF
    end
    html.html_safe
  end

  # ヘッダーに表示する本の冊数アイコン
  def mybookshelf_books(count)
    html = ""
    if count == 1
      html += <<-EOF
        <img height="18" src="#{asset_path("last-book.png")}" class="last-book" />
      EOF
    elsif !count.nil? && count > 1
      for i in 1..count do
        if i == count
          html += <<-EOF
          <img height="18" src="#{asset_path ("last-book.png")}" class="last-book" />
          EOF
        elsif i == 1
          html += <<-EOF
          <img height="18" src="#{asset_path ("first-book.png")}" class="first-book"/>
          EOF
        else
          html += <<-EOF
          <img height="18" src="#{asset_path ("first-book.png")}" class="first-book"/>
          EOF
        end
      end
    end
    html.html_safe
  end
end
