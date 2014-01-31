class Item < ActiveRecord::Base

  belongs_to :wallet
  
  before_create :set_default_name
  before_create :set_default_delta
  before_create :set_default_time

  acts_as_taggable
  
  self.per_page = 10

private

  def set_default_name
    if not self.name or self.name == ''
      self.name = 'N/A'
    end
  end

  def set_default_delta
    if not self.delta
      self.delta = 0.0
    end
  end

  def set_default_time
    if not self.time
      self.time = Time.now
    end
  end

end
