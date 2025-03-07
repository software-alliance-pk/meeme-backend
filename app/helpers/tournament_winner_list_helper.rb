module TournamentWinnerListHelper
    def get_most_liked_post(tournament_user, banner_id)
      # Initialize variables
      @most_liked_post = nil
      highest_score = nil

      # Iterate through all posts for the tournament banner
      tournament_user.user.posts&.where(tournament_banner_id: banner_id, deleted_by_user: false)&.where("flagged_by_user = '{}' OR array_length(flagged_by_user, 1) IS NULL").each do |post|
        likes = post&.likes&.where(status: 'like')&.count || 0
        dislikes = post&.likes&.where(status: 'dislike')&.count || 0

        # Skip posts with 0 likes and 0 dislikes
        next if likes.zero? && dislikes.zero?

        score = likes - dislikes # Calculate score
        
        # Update most liked post if the current post has a higher score
        if @most_liked_post.nil? || score > highest_score
          @most_liked_post = post
          highest_score = score
        end
      end
      # Return the post with the highest score
      @most_liked_post
      
    end
    
end