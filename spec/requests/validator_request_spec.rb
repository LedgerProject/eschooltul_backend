require "rails_helper"

RSpec.describe "Validators", type: :request do
  describe "#create" do
    let(:transaction_id_present_in_blockchain) do
      "c274b56ed205ea14139687bd235e295acf430a309b71ea54b0d6215813f060754bee25"
    end

    it "validates with blockchain", :vcr do
      report_pdf = file_fixture("report-in-blockchain.pdf")
      content_hash = Report.calculate_hash(report_pdf.read)
      create(
        :report,
        content_hash: content_hash,
        transaction_id: transaction_id_present_in_blockchain
      )
      pdf_file = fixture_file_upload(report_pdf)

      post "/validators", params: { validator: { file: pdf_file } }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq("It's certified by Eschooltul.")
    end

    context "when the report doesn't exist" do
      it "shows error message" do
        pdf_file = fixture_file_upload(file_fixture("report-in-blockchain.pdf"))

        post "/validators", params: { validator: { file: pdf_file } }

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq("The report is not certified by Eschooltul.")
      end
    end
  end
end
