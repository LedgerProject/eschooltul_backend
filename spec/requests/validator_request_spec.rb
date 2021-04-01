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

    context "when the report is not certified" do
      it "show error message when transaction_id doesn't exist" do
        director = create(:user, :director)
        sign_in(director)
        student = create(:student)
        mark = create(:mark, :with_course, student: student)
        course = mark.remarkable
        pdf_file = fixture_file_upload(file_fixture("report-in-blockchain.pdf"))
        pdf = pdf_file.read
        report = create(
          :report,
          content: Base64.encode64(pdf),
          content_hash: Report.calculate_hash(pdf),
          course: course,
          student: student,
          date: Time.zone.today
        )
        allow(Report).to receive(:calculate_hash).and_return(report.content_hash)

        post "/validators", params: { validator: { file: pdf_file } }

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq("The report is not certified by Eschooltul.")
      end
    end

    context "when report is not present in blockchain" do
      it "show error when response from reading blockchain is not correct", :vcr do
        director = create(:user, :director)
        sign_in(director)
        student = create(:student)
        mark = create(:mark, :with_course, student: student)
        course = mark.remarkable
        pdf_file = fixture_file_upload(file_fixture("report-in-blockchain.pdf"))
        pdf = pdf_file.read
        report = create(
          :report,
          content: Base64.encode64(pdf),
          content_hash: Report.calculate_hash(pdf),
          transaction_id: "1",
          course: course,
          student: student,
          date: Time.zone.today
        )
        allow(Report).to receive(:calculate_hash).and_return(report.content_hash)

        post "/validators", params: { validator: { file: pdf_file } }

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq("There has been an error in reading data from the blockchain.")
      end
    end
  end
end
