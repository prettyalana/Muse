class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.where(sender: current_user).or(Message.where(recipient: current_user)).group_by(&:listing_id)
  end

  # GET /messages/new
  def new
    @message = Message.new(
      recipient_id: params[:recipient_id],
      listing_id: params[:listing_id],
    )
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
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
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

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:recipient_id, :listing_id, :body)
  end
end
