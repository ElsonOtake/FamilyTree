class CouplesController < ApplicationController
  before_action :set_couple, only: %i[ show edit update destroy ]

  # GET /couples or /couples.json
  def index
    @couples = Couple.all
  end

  # GET /couples/1 or /couples/1.json
  def show
  end

  # GET /couples/new
  def new
    @couple = Couple.new
  end

  # GET /couples/1/edit
  def edit
  end

  # POST /couples or /couples.json
  def create
    @couple = Couple.new(couple_params)

    respond_to do |format|
      if @couple.save
        format.html { redirect_to couple_url(@couple), notice: "Couple was successfully created." }
        format.json { render :show, status: :created, location: @couple }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @couple.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couples/1 or /couples/1.json
  def update
    respond_to do |format|
      if @couple.update(couple_params)
        format.html { redirect_to couple_url(@couple), notice: "Couple was successfully updated." }
        format.json { render :show, status: :ok, location: @couple }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @couple.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couples/1 or /couples/1.json
  def destroy
    @couple.destroy

    respond_to do |format|
      format.html { redirect_to couples_url, notice: "Couple was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couple
      @couple = Couple.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def couple_params
      params.require(:couple).permit(:tree1_id, :tree2_id, :marriage, :separation, :local)
    end
end
