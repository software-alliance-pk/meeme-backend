namespace :story_delete do
  desc "Check Story "
  task story_check: :environment do
    @stories = Story.last
    if @stories.present?
      @stories = Story.last.destroy
      puts "Latest Story destroyed "
    end
    puts "Out of loop "
  end
end
