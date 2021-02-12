class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
  end
end
