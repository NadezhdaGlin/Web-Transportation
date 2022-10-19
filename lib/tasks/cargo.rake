namespace :statistic do
  task :cargo_file, [:id]=> :environment do |t, args|
    begin
      org_id = Organization.find(args[:id])
      widgets = [
            Cargos::CountWidget.call(org_id),
            Cargos::CountWidget.call(org_id, :sorted),
            Cargos::PriceWidget.call(org_id),
            Cargos::PriceWidget.call(org_id, :average),
            Cargos::DistanceWidget.call(org_id),
            Cargos::DistanceWidget.call(org_id, :max)
          ]
          
      widgets.each do |cargo|
        File.write('statistics.txt', "#{cargo[:text]} #{cargo[:data]}\n", mode: 'a')
      end
    rescue
      File.write('statistics.txt', "There is no data for this id\n", mode: 'a')
    end
  end
end