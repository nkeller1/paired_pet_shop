require 'rails_helper'

RSpec.describe 'create pet page', type: :feature do
  describe 'when I visit the new pet form by clicking on the link in the index' do
    it 'can create a new pet' do
      shelter_1 = Shelter.create(
        name: "Mike's Shelter",
        address: "1331 17th Street",
        city: "Denver",
        state: "CO",
        zip: 80202
      )

      visit "/shelters/#{shelter_1.id}/pets"

      click_link 'Add New Pet'

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

      fill_in :image, with: "https://image.shutterstock.com/image-photo/dog-260nw-587562362.jpg"
      fill_in :name, with: "Frankie"
      fill_in :description, with: "Cute"
      fill_in :age, with: 0
      fill_in :sex, with: "Female"

      click_on 'Create Pet'

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets")
      expect(page).to have_content('Frankie')

      new_pet = Pet.last

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets")
      expect(page).to have_css("img[src*='#{new_pet.image}']")
      expect(page).to have_content(new_pet.name)
      expect(page).to have_content(new_pet.age)
      expect(page).to have_content(new_pet.sex)
    end

    it "has a flash message if a form is incomplete when creating a pet" do
      shelter_1 = Shelter.create(
         name: "Mike's Shelter",
         address: "1331 17th Street",
         city: "Denver",
         state: "CO",
         zip: 80202
       )

      visit "/shelters/#{shelter_1.id}/pets"

      click_link 'Add New Pet'

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

      #No name included in form
      fill_in :image, with: "https://image.shutterstock.com/image-photo/dog-260nw-587562362.jpg"
      fill_in :description, with: "Cute"
      fill_in :age, with: 0
      fill_in :sex, with: "Female"

      click_on 'Create Pet'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
