class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
    Topic.create([
      { name: 'سبک زندگی',     subdomain: 'lifestyle' }, 
      { name: 'گردشگری',       subdomain: 'tourism' }, 
      { name: 'چهره ها',       subdomain: 'celebrity' }, 
      { name: 'آشپزی',         subdomain: 'cookery' }, 
      { name: 'سلامت',         subdomain: 'health' }, 
      { name: 'دکوراسیون',     subdomain: 'decoration' }, 
      { name: 'فرهنگ و هنر',   subdomain: 'art' }, 
      { name: 'موفقیت',        subdomain: 'success' }, 
      { name: 'دانش و فناوری', subdomain: 'technology' }, 
      { name: 'کودک',          subdomain: 'baby' }, 
      { name: 'سرگرمی',        subdomain: 'fun' }, 
      { name: 'دانلود',        subdomain: 'download' }
    ])
  end
end
