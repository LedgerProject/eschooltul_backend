require "rails_helper"

RSpec.describe "Accounts", type: :request do
  describe "POST /accounts" do
    it "creates a new user" do
      director = create(:user, :director)
      sign_in(director)
      role = create(:role)

      attributes = {
        email: "edna@mail.com",
        password: "password",
        password_confirmation: "password",
        name: "Edna",
        first_surname: "Krabappel",
        second_surname: "Skinner",
        role_ids: role.id.to_s
      }

      post accounts_path, params: { user: attributes }

      expect(response).to redirect_to(accounts_path)
      expect(User.with_role(:teacher).count).to be(1)
    end
  end

  describe "DELETE /account/:id" do
    it "deletes an account" do
      director = create(:user, :director)
      teacher = create(:user, :teacher)
      sign_in(director)

      delete account_path(teacher)

      expect(response).to redirect_to(accounts_path)
      expect(User.with_role(:teacher).count).to be(0)
    end

    context "when there's only one director left" do
      it "doesn't delete de account" do
        director = create(:user, :director)
        sign_in(director)

        delete account_path(director)

        expect(response).to redirect_to(accounts_path)
        expect(User.with_role(:director).count).to be(1)
      end
    end
  end
end
