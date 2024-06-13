module TournamentWinnerListHelper
    def get_most_liked_post(tournament_user, banner_id)
        @most_liked_post = tournament_user.user.posts&.where(tournament_banner_id: banner_id).first
        likes = tournament_user.user.posts&.where(tournament_banner_id: banner_id).first&.likes&.like&.count
        tournament_user.user.posts&.where(tournament_banner_id: banner_id)&.each do |post|
            if post.likes.like.count > likes
                @most_liked_post = post
                likes = post.likes&.like&.count
            end
        end
        @most_liked_post
    end
    
end