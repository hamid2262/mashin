desc "inactive old ads" 
task :inactive_old_ads => :environment do
  Ad.where(status: 2).where("updated_at < ?", 2.weeks.ago).update_all(status: 5)
end