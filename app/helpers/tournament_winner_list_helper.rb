module TournamentWinnerListHelper
    def get_most_liked_post(tournament_user, banner_id)
        @most_liked_post = tournament_user.user.posts&.first
        likes = tournament_user.user.posts&.first.likes.like.count
        tournament_user.user.posts&.each do |post|
            if post.likes.like.count > likes
                @most_liked_post = post
            end
        end
        @most_liked_post
    end
    
end