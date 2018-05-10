require 'test_helper'

class WarningReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get warning_report_index_url
    assert_response :success
  end

  test "should get create" do
    get warning_report_create_url
    assert_response :success
  end

end
