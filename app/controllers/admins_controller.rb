class AdminsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin_application'
  def top
    #ログイン後の表示画面
    @warning_reports_count = WarningReport.where(dealt: false).count
  end
end
