class Message < ActiveRecord::Base
  
  attr_accessible :body, :user, :discussion

  default_scope order(:created_at)

  belongs_to :discussion, :counter_cache => true, :touch => true
  belongs_to :user

  validates :user, :discussion, :body, :presence => true

  after_save :mark_discussion_as_read

  def visible_for? user
    self.created_at.to_i >= self.discussion.user_invited_at(user).to_i
  end
  
  def unread_for? user
    speaker = self.discussion.find_speaker_by_user(user)
    if speaker
      self.created_at.to_i >= speaker.updated_at.to_i
    else
      true
    end
  end
  
  def reset_discussion_reads
    discussion.speakers.where("user_id <> ?", user_id).each do |speaker|
      speaker.update_attribute(:last_message_read, false)
    end
  end
  


  private

  def mark_discussion_as_read
    self.discussion.mark_as_read_for(self.user)
  end
  
  
end
