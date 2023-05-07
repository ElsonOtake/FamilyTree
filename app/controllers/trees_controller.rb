class TreesController < ApplicationController
  before_action :set_tree, only: %i[ show edit update destroy ]

  # GET /trees or /trees.json
  def index
    @trees = Tree.all
  end

  # GET /trees/1 or /trees/1.json
  def show
    @parents = @tree.couples
    if @parents.empty?
      @father = nil
      @mother = nil
    else
      if Tree.find(@parents[0].tree1_id).gender = "M"
        @father = Tree.find(@parents[0].tree2_id)
        @mother = Tree.find(@parents[0].tree1_id)
      else
        @father = Tree.find(@parents[0].tree1_id)
        @mother = Tree.find(@parents[0].tree2_id)
      end
    end
      
    couple = Couple.where(tree1_id: @tree).or(Couple.where(tree2_id: @tree))
    if couple.empty?
      @mate = nil
      @children = nil
    else
      @mate = Tree.find(couple[0].tree1_id) if couple[0].tree1_id != @tree.id
      @mate = Tree.find(couple[0].tree2_id) if couple[0].tree2_id != @tree.id
      @children = couple[0].trees
    end


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
