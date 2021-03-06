require 'rails_helper'
RSpec.describe "favorites index page", type: :feature do
    before do
      @shelter_2 = Shelter.create!(
        name: "Meg's Shelter",
        address: "150 Main Street",
        city: "Hershey",
        state: "PA",
        zip: 17033
      )
      @pet_1 = Pet.create(
        image: "https://image.shutterstock.com/image-photo/playing-dogs-garden-260nw-1556131820.jpg",
        name: "Fido",
        description: "Silly",
        age: 2,
        sex: "Female",
        adoption_status: "open",
        shelter: @shelter_2
      )
      @pet_2 = Pet.create(
        image: "https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2019/09/Dogs-portrait-3.jpg?w=750",
        name: "Nelly",
        description: "butthead",
        age: 3,
        sex: "Male",
        adoption_status: "open",
        shelter: @shelter_2
      )
      @pet_3 = Pet.create(
        image: "https://image.shutterstock.com/image-photo/dog-headshot-on-yellow-background-260nw-324936848.jpg",
        name: "Sammy",
        description: "Adorable",
        age: 4,
        sex: "Male",
        adoption_status: "open",
        shelter: @shelter_2
      )
    end

    after do
      PetApplication.destroy_all
    end

    it "can see favorited pets" do
      visit "/pets/#{@pet_1.id}"
      click_on "Favorite Pet"
      visit "/pets/#{@pet_2.id}"
      click_on "Favorite Pet"
      visit "/pets/#{@pet_3.id}"
      click_on "Favorite Pet"
      visit '/favorites'
      expect(page).to have_link("#{@pet_1.name}")
      expect(page).to have_css("img[src*='#{@pet_1.image}']")
      expect(page).to have_link("#{@pet_2.name}")
      expect(page).to have_css("img[src*='#{@pet_2.image}']")
      expect(page).to have_link("#{@pet_3.name}")
      expect(page).to have_css("img[src*='#{@pet_3.image}']")
  end

  it "can remove a pet from the favorites page" do

    visit "/pets/#{@pet_1.id}"
    click_on "Favorite Pet"

    visit "/pets/#{@pet_2.id}"
    click_on "Favorite Pet"

    visit "/pets/#{@pet_3.id}"
    click_on "Favorite Pet"

    visit '/favorites'

    expect(page).to have_content("(3) Favorited Pets")

    within("#favoritepet-#{@pet_1.id}") do
      expect(page).to have_button("Remove Pet From Favorites")
      click_on "Remove Pet From Favorites"
    end


    expect(current_path).to eq('/favorites')

    within("#favoritepets") do
      expect(page).to_not have_link("#{@pet_1.name}")
    end

    expect(page).to_not have_css("img[src*='#{@pet_1.image}']")
    expect(page).to have_content("(2) Favorited Pets")

    within("#favoritepet-#{@pet_2.id}") do
      expect(page).to have_button("Remove Pet From Favorites")
      click_on "Remove Pet From Favorites"
    end

    expect(current_path).to eq('/favorites')
    within("#favoritepets") do
      expect(page).to_not have_link("#{@pet_2.name}")
    end

    expect(page).to_not have_css("img[src*='#{@pet_2.image}']")
    expect(page).to have_content("(1) Favorited Pets")
  end

  it "can see message if not pets are favorited" do
    visit "/favorites"
    expect(page).to have_content("(0) Favorited Pets")
    expect(page).to have_content("You have no pets favorited!")
  end

  it "can remove all Favorites from Favorites Page" do
    visit "/pets/#{@pet_1.id}"
    click_on "Favorite Pet"

    visit "/pets/#{@pet_2.id}"
    click_on "Favorite Pet"

    visit '/favorites'

    expect(page).to have_link("Remove All Pets From Favorites")
    click_on "Remove All Pets From Favorites"

    expect(current_path).to eq('/favorites')
    expect(page).to have_content("You have no pets favorited!")
    expect(page).to have_content("(0) Favorited Pets")
  end

  it "can see a section on the page that has all of the pets that have an applicaiton" do
    visit "/pets/#{@pet_1.id}"
    click_on "Favorite Pet"

    visit "/pets/#{@pet_2.id}"
    click_on "Favorite Pet"

    visit '/favorites'

    click_on "Adopt My Favorite Pets"

    expect(current_path).to eq('/applications/new')

    within "#favorite-#{@pet_1.id}" do
      check "adopt_pets[]"
    end

    within "#favorite-#{@pet_2.id}" do
      check "adopt_pets[]"
    end

    fill_in :name, with: "Nathan Keller"
    fill_in :address, with: "1234 Main St"
    fill_in :city, with: "Arvada"
    fill_in :state, with: "CO"
    fill_in :zip, with: 80003
    fill_in :phone_number, with: "303-725-6266"
    fill_in :description_why, with: "I LOVE DOGS"
    click_on "Submit Application"

    visit '/favorites'

    expect(page).to have_content("All Pet Applications")
    expect(page).to have_link(@pet_1.name)
    expect(page).to have_link(@pet_2.name)
  end
end
