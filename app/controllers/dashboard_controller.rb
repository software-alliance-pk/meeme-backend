class DashboardController < ApplicationController

  def dashboard
  end

  def welcome
  end

  def signin
  end

  def signup
  end

  def forgot_password
  end

  def reset_password
  end

  def verification
  end

  def notifications
  end

  def admin_profile
  end

  def tournament
    @tournament_banner= Like.where(is_judged:true,status: 'like').joins(:post).where(post: { tournament_banner_id: 1, tournament_meme: true }).
      group(:post_id).count(:post_id).sort_by(&:last).sort_by(&:last).reverse.to_h
    @posts=Post.where(id: @tournament_banner.keys)
  end

  def tournament_banner
    @tournament_banner= TournamentBanner.all
  end

  def winner_detail
  end

  def user_list
  end

  def gift_rewards
  end

  def transactions
  end

  def faqs
  end

  def faqs_edit
  end

  def popup
  end

  def popup_edit
  end

  def privacy
  end

  def privacy_edit
  end

  def terms
  end

  def terms_edit
  end

  def support
  end


end
