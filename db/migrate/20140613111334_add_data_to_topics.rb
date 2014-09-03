class AddDataToTopics < ActiveRecord::Migration
  def up
    Topic.create([
      { name: 'سبک زندگی',     slug: 'lifestyle' }, 
      { name: 'گردشگری',       slug: 'tourism' }, 
      { name: 'چهره ها',       slug: 'celebrity' }, 
      { name: 'آشپزی',         slug: 'cookery' }, 
      { name: 'سلامت',         slug: 'health' }, 
      { name: 'دکوراسیون',     slug: 'decoration' }, 
      { name: 'فرهنگ و هنر',   slug: 'art' }, 
      { name: 'موفقیت',        slug: 'success' }, 
      { name: 'دانش و فناوری', slug: 'technology' }, 
      { name: 'کودک',          slug: 'baby' }, 
      { name: 'سرگرمی',        slug: 'fun' }, 
      { name: 'دانلود',        slug: 'download' }
    ])
  end
end
