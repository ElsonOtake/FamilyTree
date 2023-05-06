class TreesController < ApplicationController
  before_action :set_tree, only: %i[ show edit update destroy ]

  # GET /trees or /trees.json
  def index
    @trees = Tree.all
  end

  # GET /trees/1 or /trees/1.json
  def show
  end

  # GET /trees/new
  def new
    @tree = Tree.new
  end

  # GET /trees/1/edit
  def edit
  end

  # POST /trees or /trees.json
  def create
    @tree = Tree.new(tree_params)

    respond_to do |format|
      if @tree.save
        format.html { redirect_to tree_url(@tree), notice: "Tree was successfully created." }
        format.json { render :show, status: :created, location: @tree }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1 or /trees/1.json
  def update
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to tree_url(@tree), notice: "Tree was successfully updated." }
        format.json { render :show, status: :ok, location: @tree }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1 or /trees/1.json
  def destroy
    @tree.destroy

    respond_to do |format|
      format.html { redirect_to trees_url, notice: "Tree was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree
      @tree = Tree.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tree_params
      params.require(:tree).permit(:name, :gender, :alive, :birth, :death, :description)
    end
end
