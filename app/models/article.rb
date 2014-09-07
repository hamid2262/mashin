class Article < ActiveRecord::Base
  belongs_to :topic
  belongs_to :subtopic

  def to_param    
    filterd = title.delete("/(){}[]:.|/!^%$*?؟،×") 
    "#{id}-" + "#{filterd}".gsub(" ","-")
  end

  def source
    if url.include? "varzesh3.com"
      "varzesh3" 
    elsif url.include? "bartarinha.ir"
      "bartarinha"
    elsif url.include? "beytoote.com"
      "beytoote"
    end
  end

  def self.with_image
    where(" thumb <> '' ").limit(50)
  end

  def self.sorted 
    order(updated_at: :desc)
  end

  def same_subtopic_articles
    Article.where(subtopic_id: sisters.ids).order("RANDOM()").limit(30)
  end

private

  def sisters
    Subtopic.where(deligate: self.subtopic.deligate)
  end

end
