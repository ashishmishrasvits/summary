require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    context "create" do
        it "creates user when email is passed in request" do
            post :create, params: { email: "email@email.com"}
            expect(JSON.parse(response.body)).to include("message"=>"user successfully created")
            expect(response.status).to eql 200
        end

        it "raises error when no email is passed" do
            post :create, params: { email: ""}
            expect(JSON.parse(response.body)).to include("message" => "Validation failed: Email is invalid")
            expect(response.status).to eql 422
        end

        it "raises error when email already exists" do
            create(:user,email:"email@email.com")
            post :create, params: { email: "email@email.com"}
            expect(JSON.parse(response.body)).to include("message"=>"Validation failed: Email has already been taken")
            expect(response.status).to eql 422 
        end
    end
end
