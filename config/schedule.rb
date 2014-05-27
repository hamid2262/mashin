set :output, "#{path}/log/cron.log"

every "1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58 * * * *" do
  rake "scrap_bama"
end

every "2,14,26,38,50 * * * *" do
  rake "scrap_takhtegaz"
end

every "0,6,12,18,24,30,36,42,48,54 * * * *" do
  rake "scrap_tejarat"
end

#############################3
every "0 0,2,4,6,8,10,12,14,16,18,20,22 * * *" do
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