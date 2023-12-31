require 'rails_helper'

describe "Rating" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path

    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{ Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "shows the number of ratings" do
    create_beer_with_rating({ user: }, 25)
    create_beer_with_rating({ user: }, 25)

    visit ratings_path

    expect(page).to have_content "Total ratings: 2"
  end
end
