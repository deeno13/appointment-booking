class PagesController < ApplicationController
  def home
    @trainers = Trainer.all
  end
end
