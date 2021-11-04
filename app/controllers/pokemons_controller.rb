class PokemonsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @pokemons = policy_scope(Pokemon)

    # the `geocoded` scope filters only pokemons with coordinates (latitude & longitude)
    @markers = @pokemons.geocoded.map do |pokemon|
      {
        lat: pokemon.latitude,
        lng: pokemon.longitude,
        info_window: render_to_string(partial: "info_window", locals: { pokemon: pokemon })
      }
    end
  end

  def show
		@pokemon = Pokemon.find(params[:id])
    authorize @pokemon
	end

  def new
    @pokemon = Pokemon.new
		authorize @pokemon
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.user = current_user
		authorize @pokemon

    if @pokemon.save
      @kinds = Kind.where(id: params[:pokemon][:kind_ids])
      @kinds.each do |kind|
        kind_pokemon = KindPokemon.new(pokemon: @pokemon, kind: kind)
        kind_pokemon.save
      end
      redirect_to pokemon_path(@pokemon)
    else
      render :new
    end
  end

  private

  def pokemon_params
    params.require(:pokemon).permit(:name, :description, :price, :location, :photo)
  end
end
