class TournamentBanner < ApplicationRecord
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :posts
  has_many :likes
  has_one_attached :tournament_banner_photo ,dependent: :destroy
  has_one :ranking_price,dependent: :destroy
  has_one :tournament_banner_rule,dependent: :destroy

  # after_create_commit :compress
  #
  # def compress
  #   if self.tournament_banner_photo.present? && self.tournament_banner_photo.content_type[0...5] == "image"
  #     @image = self.tournament_banner_photo.variant(quality: 45).processed.url
  #     self.update(compress_image: @image)
  #   end
  # end

end