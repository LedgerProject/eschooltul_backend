require "rails_helper"

RSpec.describe ImportEdRecord, type: :model do
  describe "#upload_records" do
    it "uploads a spreadsheet to the database" do
      filename = "EdRecord.xlsx"
      io = File.open(Rails.root.join("spec", "fixtures", "files", filename))
      file = described_class.new({ attachment: io })

      file.upload_records

      expect(Student.count).to be(4)
    end
  end
end
