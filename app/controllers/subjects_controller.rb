class SubjectsController < ApplicationController
  def index
    redirect_to Subject.root
  end

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

  def search_materials
    @subjects = Subject.materials_query(params[:q])

    respond_to do |format|
      format.json { render json: @subjects }
    end
  end

  def complete
    @subjects = Subject.complete(params[:q], size: 7)

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
