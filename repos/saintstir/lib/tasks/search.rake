
namespace :search do
  namespace :refresh do
    desc "Refresh search index in full"
    task :all => :environment do
      Search::Saint.refresh_index_full
    end
  end
end
