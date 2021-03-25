require "rails_helper"

RSpec.describe "Validators", type: :request do
  describe "#create" do
    context "when the report doesn't exist" do
      it "shows error message" do
        pdf_file = fixture_file_upload(file_fixture("report-in-blockchain.pdf"))

        post "/validators", params: { validator: { file: pdf_file } }

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq("The report is not in the Eschooltul database.")
      end
    end
  end
end
