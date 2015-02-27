class GamesController < ApplicationController
  def index
    render json: Game.page(page)
  end

  def react
  end

  def html
    @games = Game.all
  end

  private

  def page
    params.fetch(:page, 1).to_i
  end
end
