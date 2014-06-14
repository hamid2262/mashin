class Article < ActiveRecord::Base
  belongs_to :topic

  def to_param    
    filterd = title.delete("/(){}[]:.|/!^%$*?؟،×") 
    "#{id}-" + "#{filterd}".gsub(" ","-")
  end

  def source
    if url.include? "varzesh3.com"
      "varzesh3" 
    elsif url.include? "bartarinha.ir"
      "bartarinha"
    end
  end
end
