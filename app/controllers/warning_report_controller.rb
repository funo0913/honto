class WarningReportController < ApplicationController
  def index
  end

  def create
    warning = WarningReport.new
    warning.review_id = params[:id]
    warning.user_id = current_user.id
    warning.save
    redirect_to review_path(params[:id]), notice: '通報しました'
  end
end
