class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
  end

  def random
    redirect_to Subject.sample
  end

  def random_material
    rand_id = Subject.facet(:materials).descendant_ids.sample
    redirect_to Subject.find(rand_id)
  end
end
