set :output, "#{path}/log/cron.log"

every 1.minutes do
  rake "scrap_bama"
end

# every 3.minutes do
#   rake "scrap_tejarat"
# end

every 30.minutes do
  rake "scrap_takhtegaz"
end

############################
every 5.minutes do
  rake "triger_bama_scrap"
end

# every 30.minutes do
#   rake "triger_tejarat_scrap"
# end

every 1.hour do
  rake "triger_takhtegaz_scrap"
end

#############################
every 1.days, at: '21:10' do
  rake "clear_bamadb"
end
# every 1.days, at: '21:20' do
#   rake "clear_tejaratdb"
# end
every 1.days, at: '21:30' do
  rake "clear_takhtegazdb"
end

#############################
every 1.days, at: '22:00' do
  rake "inactive_old_ads"
end

########### articles #######
# every 1.hours do
#   rake "scrap_articles"
# end

# every 2.hours do
#   rake "articles_scrap_triger"
# end