class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
  end

  def random
    redirect_to Subject.sample
  end
end
