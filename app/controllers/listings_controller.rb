class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy ]
  before_action :ensure_current_user_is_buyer, only: [:destroy, :update, :edit]

  # GET /listings or /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.buyer_id = current_user.id

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    if current_user == @listing.buyer
        @listing.destroy

        respond_to do |format|
        format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_back(fallback_location: root_url, notice: "Not authorized!")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def ensure_current_user_is_buyer
      if current_user != @listing.buyer
        redirect_back fallback_location: root_url,
        alert: "You're not authorized for that."
      end
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:image, :caption, :category_id, :buyer_id, :purchased)
    end
end
