require 'rails_helper'

RSpec.describe "shelter new page", type: :feature do
  it "can can create a new shelter" do
    shelter_1 = Shelter.create(
       name: "Mike's Shelter",
       address: "1331 17th Street",
       city: "Denver",
       state: "CO",
       zip: 80202
     )

    visit "/shelters"
    expect(page).to have_link("Create New Shelter")

    click_on "Create New Shelter"
    expect(current_path).to eq('/shelters/new')

    fill_in :name, with: "Nate's Shelter"
    fill_in :address, with: "123 Bark Plaza"
    fill_in :city, with: "Aurora"
    fill_in :state, with: "CO"
    fill_in :zip, with: 80014

    click_on "Create Shelter"

    expect(current_path).to eq('/shelters')

    new_shelter = Shelter.last
    expect(page).to have_content("Nate's Shelter")
  end

  it "shows an error message when a form is blank" do

    visit "/shelters"
    expect(page).to have_link("Create New Shelter")

    click_on "Create New Shelter"
    expect(current_path).to eq('/shelters/new')

    #name is blank
    fill_in :name, with: ""
    fill_in :address, with: "123 Bark Plaza"
    fill_in :city, with: "Aurora"
    fill_in :state, with: "CO"
    fill_in :zip, with: 80014

    click_on "Create Shelter"

    expect(page).to have_content("Name can't be blank")
  end

end
