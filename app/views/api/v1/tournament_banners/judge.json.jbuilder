json.tournament_banner @tournament
json.tournament_days @tournamnet_days
json.tournament_banner_image @tournament.tournament_banner_photo.attached? ? @tournament.tournament_banner_photo.blob.url : ''
json.judged_posts do
  json.array! (@difference+1).times do |num|
    json.judged_post_date_count @posts_judged.where(created_at: (@tournament_start_date + num).beginning_of_day..(@tournament_start_date + num).end_of_day).count
    json.status   @posts_judged.where(created_at: (@tournament_start_date + num).beginning_of_day..(@tournament_start_date + num).end_of_day).count > 24 ? true : false
    json.post_date (@tournament_start_date + num).end_of_day
    json.post_date_posts @posts_judged.where(created_at: (@tournament_start_date + num).beginning_of_day..(@tournament_start_date + num).end_of_day).each do |post|
      json.posts post
    end
  end
end
