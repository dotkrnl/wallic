require 'SecureRandom'

class Wallet < ActiveRecord::Base

  before_create :set_default_info
  before_create :set_default_secret

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

private

  def set_default_info
    if not self.name or self.name == ''
      self.name = 'Untitled'
    end
    if not self.detail or self.detail == ''
      self.detail = 'yet anothor wallet'
    end
  end

  def set_default_secret
    if not self.secret_read
      self.secret_read = generate_secret
    end
    if not self.secret_rw
      self.secret_rw = generate_secret
    end
  end

  def generate_secret
    SecureRandom.hex Global.security.secret_len
  end

end
