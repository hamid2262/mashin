set :output, "#{path}/log/cron.log"

every "1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58 * * * *" do
  rake "scrap_bama"
end

every "2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59 * * * *" do
  rake "scrap_takhtegaz"
end

every "0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * *" do
  rake "scrap_tejarat"
end

#############################3
every "0 0,2,4,6,8,10,12,14,16,18,20,22 * * *" do
  rake "triger_bama_scrap"
  rake "triger_takhtegaz_scrap"
  rake "triger_tejarat_scrap"
end

#############################
every 1.days, at: '20:00' do
  rake "clear_bamadb"
  rake "clear_takhtegazdb"
  rake "clear_tejaratdb"
end