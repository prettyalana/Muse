class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :set_listing, only: [:message_thread]

  # GET /messages or /messages.json
  def index
    @messages = Message.where(sender: current_user).or(Message.where(recipient: current_user)).group_by(&:listing_id)
  end

  def message_thread
    @messages = Message.where(listing_id: @listing.id).where(sender: current_user).or(Message.where(recipient: current_user, listing_id: @listing.id))
    @user = current_user
  end

  # GET /messages/new
  def new
    @listing = Listing.find(params[:listing_id])
    @message = Message.new(listing: @listing)

    if current_user.seller?
      @message.recipient_id = @listing.buyer_id
    else
      last_message = Message.where(listing: @listing).where.not(sender_id: current_user.id).order(created_at: :desc).first

      if last_message.present?
        @message.recipient_id = last_message.sender_id
      else
        flash[:alert] = "No previous message to reply to."
        redirect_to listings_path and return
      end
    end
  end

  # POST /messages or /messages.json
  def create
    Rails.logger.debug "Incoming parameters: #{params.inspect}"
    @message = Message.new(message_params)
    @message.sender_id = current_user.id

    Rails.logger.debug "Creating message with params: #{message_params.inspect}"
    Rails.logger.debug "Message attributes: #{@message.attributes.inspect}"

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        Rails.logger.debug "Message errors: #{@message.errors.full_messages}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  def set_listing
    @listing = Listing.find_by(id: params[:listing_id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:sender_id, :recipient_id, :listing_id, :body, :image)
  end
end
