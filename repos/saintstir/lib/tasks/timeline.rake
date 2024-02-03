##
#  All timeline-related rake tasks
namespace :timeline do


  namespace :refresh do 

    desc "Refresh all timelines" 
    task :all => :environment do
      TimelineService.timelines.each do |tl|
        TimelineService.render_by_type(tl.type, true)
      end
    end

    desc "Refresh feastday timeline" 
    task :feastday => :environment do 
      puts "Refreshing timeline: feastday"
      TimelineService.render_by_type(Timeline::Feastday.new.type, true)
    end

    desc "Refresh century timeline" 
    task :century => :environment do 
      puts "Refreshing timeline: century"
      TimelineService.render_by_type(Timeline::Century.new.type, true)
    end

    desc "Refresh euro period timeline" 
    task :europeriod => :environment do 
      puts "Refreshing timeline: europeriod"
      TimelineService.render_by_type(Timeline::Europeriod.new.type, true)
    end

  end
end




