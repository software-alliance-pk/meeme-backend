module TournamentWinnerListHelper
    def get_most_liked_post(tournament_user, banner_id)
      # Initialize variables
      @most_liked_post = tournament_user.user.posts.where(tournament_banner_id: banner_id).first
      highest_score = tournament_user.user.posts.where(tournament_banner_id: banner_id).first.likes&.where(status: 'like')&.count - tournament_user.user.posts.where(tournament_banner_id: banner_id).first.likes.where(status: 'dislike')&.count

      # Iterate through all posts for the tournament banner
      tournament_user.user.posts&.where(tournament_banner_id: banner_id)&.each do |post|
        likes = post&.likes&.where(status: 'like')&.count
        dislikes = post&.likes&.where(status: 'dislike')&.count
        score = likes - dislikes # Calculate score
        
        # Update most liked post if the current post has a higher score
        if score > highest_score
          @most_liked_post = post
          highest_score = score
        end
      end
      # Return the post with the highest score
      @most_liked_post
      
    end
    
end