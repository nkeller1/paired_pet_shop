class FavoritesController < ApplicationController
  def create
    pet = Pet.find(params[:pet_id])
    if favorites.pets == []
      favorites.add_pet(pet)
      flash[:success] = "#{pet.name} has been added to your favorites!"
    else
      favorites.add_pet(pet)
      flash[:success] = "#{pet.name} has been added to your favorites!"
    end
    redirect_to "/pets/#{pet.id}"
  end

  def index
  end
end
