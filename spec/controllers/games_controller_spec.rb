require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  render_views

  context "when responding to requests" do
    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response).to render_template("index")
      end
    end

    describe "POST #create" do
      it "redirects to the page for a fresh Game" do
        post :create
        game = Game.order(:created_at).last
        expect(response).to redirect_to(game_url(game))
      end
    end

    describe "GET #show" do
      it "shows an existing game" do
        game = Game.create!
        get :show, id: game.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response).to render_template("show")
        expect(assigns(:game)).to eq(game)
      end

      it "handles attempts to show a missing game" do
        expect { get :show, id: 10 }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
