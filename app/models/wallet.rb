class Wallet < ActiveRecord::Base

  has_many :items, dependent: :destroy

  def auth!(session, token)
    if not session[self.id]
      session[self.id] = {
        :read => false, :write => false
      }
    end
    if self.secret_read == token
      session[self.id][:read] = true
    elsif self.secret_rw == token
      session[self.id][:read] = true
      session[self.id][:write] = true
    end
  end
  
  def read?(session)
    session[self.id] and session[self.id][:read]
  end

  def write?(session)
    session[self.id] and session[self.id][:write]
  end

end
