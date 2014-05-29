set :output, "#{path}/log/cron.log"

every 2.minutes do
  rake "scrap_bama"
end

every 6.minutes do
  rake "scrap_tejarat"
end

every 15.minutes do
  rake "scrap_takhtegaz"
end

#############################3
every 10.minutes do
  rake "triger_bama_scrap"
end

every 55.minutes do
  rake "triger_tejarat_scrap"
end

every 31.minutes do
  rake "triger_takhtegaz_scrap"
end

#############################
every 1.days, at: '20:00' do
  rake "clear_bamadb"
  rake "clear_takhtegazdb"
  rake "clear_tejaratdb"
end