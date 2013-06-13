class Inboxes::MessagesController < Inboxes::BaseController
  load_and_authorize_resource :discussion
  load_resource :message, :through => :discussion, :shallow => true

  def create
    @message.user = current_user
    @message.discussion = @discussion
    @message.save
    @message.reset_discussion_reads
    
    Mailer.new_message(@message).deliver

    respond_to do |format|
      format.html { redirect_to @message.discussion }
      format.js
    end
  end
end
