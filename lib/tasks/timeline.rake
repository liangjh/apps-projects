##
#  All timeline-related rake tasks
namespace :timeline do


  namespace :refresh do 

    desc "Refresh feastday timeline" 
    task :feastday => :environment do 
      puts "Refreshing feastday timeline..."
      TimelineService.render_by_type(TimelineService::Types::FEASTDAY, true)
    end

  end
end




