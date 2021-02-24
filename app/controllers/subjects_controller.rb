class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @subject }
    end
  end

  def search
    @subjects = Subject.query(params[:q])

    respond_to do |format|
      format.json { render json: @subjects }
    end
  end

  def complete
    @subjects = Subject.complete(params[:q], size: 2)

    respond_to do |format|
      format.json { render json: @subjects }
    end
  end

  def random
    redirect_to Subject.sample
  end

  def random_material
    rand_id = Subject.facet(:materials).descendant_ids.sample
    redirect_to Subject.find(rand_id)
  end
end
