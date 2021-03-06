require 'rails_helper'

RSpec.feature "Users can edit existing movies" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:movie) { FactoryGirl.create(:movie, user: user) }

  before do
    login_as(user)

    visit "/"
    click_link "Movie 1"
    click_link "Edit Movie"
  end

  scenario "with valid attributes" do
    fill_in "Title", with: "Movie 1 Edited"
    fill_in "Text", with: "Text 1 Edited"
    click_button "Update Movie"

    expect(page).to have_content "Movie 1 Edited"
    expect(page).to have_content "Text 1 Edited"
  end

  scenario "when providing invalid arttributes" do
    fill_in "Title", with: ""
    fill_in "Text", with: ""
    click_button "Update Movie"

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Text can't be blank"
  end

  scenario "with a picture" do
    fill_in "Title", with: "Movie 1"
    fill_in "Text", with: "Description 1"
    attach_file "Picture", "spec/fixtures/the_godfather.jpg"

    click_button "Update Movie"

    expect(page).to have_content "Movie 1"

    expect(page.find('#movie .picture .img-thumbnail')['src']).to have_content 'the_godfather.jpg'

    visit edit_movie_path(movie)

    attach_file "Picture", "spec/fixtures/the_godfather_2.jpg"

    click_button "Update Movie"
    expect(page.find('#movie .picture .img-thumbnail')['src']).to have_content 'the_godfather_2.jpg'
  end
end
