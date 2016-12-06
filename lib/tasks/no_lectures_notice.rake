namespace :no_lectures_notice do
  task :run => :environment do
    NoLectures.new
  end
end
