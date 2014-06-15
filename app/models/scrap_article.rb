class ScrapArticle < ActiveRecord::Base
  has_many   :articles

  def sweep
    @terminate = false
    begin
      doc = Nokogiri::HTML(open(self.url))
      single_page_sweep(doc)
    end while  @terminate == false
  end

private
  def single_page_sweep(doc)
    if index_page_rows(doc).any?
      index_page_rows(doc).each do |item|
        delete_path = item.at_css(".delete")["href"]
        url_single = url_single(item).text if url_single(item)
        next if url_single.nil?  
        if already_exist(url_single)
          open(delete_path)
          next
        end
        @article_hash = {}
        @article_hash[:url] = url_single
        single_ad_sweep(item)
        article = create_article
        puts "article #{article.id} added"  if article
        open(delete_path)
      end
    else
      @terminate = true
    end
  end

  def single_ad_sweep item
    @article_hash[:title]       = title item
    @article_hash[:thumb]       = thumb item
    @article_hash[:topic_id]    = topic_id item
    @article_hash[:subtopic_id] = subtopic_id item    
    @article_hash[:truncate]    = truncate item
  end

  def already_exist(url_single)
    if Article.find_by(url: url_single)
      puts "already exist #{url_single[11,30]} "
      true  
    else  
      false
    end
  end

  def url_single(item)
    url = item.at('.url')
  end

  def create_article
    if @article_hash[:title] and @article_hash[:topic_id] and @article_hash[:url]
      ad = Article.create!(
        title:        @article_hash[:title], 
        thumb:        @article_hash[:thumb],
        topic_id:     @article_hash[:topic_id], 
        subtopic_id:  @article_hash[:subtopic_id], 
        url:          @article_hash[:url], 
        truncate:     @article_hash[:truncate]
      )
      ad
    end
  end

  def title item
    title = item.at('.title')
    title.text.strip[0,250] if title
  end

  def topic_id item
    val = item.at('.cat1')
    if val
      val = val.text
      topic = Topic.find_by(name: val)
      if topic
        topic.id
      elsif @article_hash[:url].include? "www.beytoote.com"
        slug = @article_hash[:url].split("/")[3]
        topic = Topic.find_by(slug: slug)
        topic = Topic.create!(name: val, slug: slug) if topic.nil?
        topic.deligate = topic.id
        topic.save
        topic.id
      elsif @article_hash[:url].include? "www.bartarinha.ir"
        topic = Topic.create!(name: val)
        topic.deligate = topic.id
        topic.save
        topic.id
      end
    end
  end

  def subtopic_id item
    val = item.at('.cat2')
    if val
      val = val.text
      subtopic = Subtopic.find_by(name: val)
      if subtopic
        subtopic.id
      elsif @article_hash[:url].include? "www.beytoote.com"
        slug = @article_hash[:url].split("/")[4]
        subtopic = Subtopic.create!(name: val, slug: slug, topic_id: @article_hash[:topic_id])
        subtopic.deligate = subtopic.id
        subtopic.save
        subtopic.id
      elsif @article_hash[:url].include? "www.bartarinha.ir"
        subtopic = Subtopic.create!(name: val, topic_id: @article_hash[:topic_id])
        subtopic.deligate = subtopic.id
        subtopic.save
        subtopic.id
      end
    end
  end

  def truncate item
    val = item.at('.truncate')
    val.text if val
  end

  def thumb item
    thumb = item.at('.thumb')
    thumb.text if thumb.text.present?
  end

  def index_page_rows(doc)
    doc.search('.item') 
  end

end


