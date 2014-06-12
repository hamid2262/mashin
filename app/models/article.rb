class Article < ActiveRecord::Base
  belongs_to :topic

  def to_param    
    filterd = title.delete("/(){}[]:.|/!^%$*?؟،×") 
    "#{id}-" + "#{filterd}".gsub(" ","-")
  end

end
