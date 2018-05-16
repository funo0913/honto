require 'rails_helper'
RSpec.describe UsersController, type: :controller do
    describe 'LPページ' do
      context "LPページが正しく表示される" do
        before do
          get :top
        end
        it 'リクエストは200 OKとなること' do
          expect(response.status).to eq 200
        end
      end
    end
end
