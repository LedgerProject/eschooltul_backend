require "rails_helper"

RSpec.describe Course, type: :model do
  describe "validations" do
    subject { build(:course) }

    it { is_expected.to validate_uniqueness_of(:subject).scoped_to(:name) }
  end
end
