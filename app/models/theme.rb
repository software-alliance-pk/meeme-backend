class Theme < ApplicationRecord
  validates :title, uniqueness: true
  has_one_attached :nav_bar_image, dependent: :destroy
  has_one_attached :nav_home_icon_selected_image, dependent: :destroy
  has_one_attached :nav_explore_icon_selected_image, dependent: :destroy
  has_one_attached :nav_tournament_icon_selected_image, dependent: :destroy
  has_one_attached :nav_profile_icon_selected_image, dependent: :destroy
  has_one_attached :nav_home_icon_unselected_image, dependent: :destroy
  has_one_attached :nav_explore_icon_unselected_image, dependent: :destroy
  has_one_attached :nav_tournament_icon_unselected_image, dependent: :destroy
  has_one_attached :nav_profile_icon_unselected_image, dependent: :destroy
  has_one_attached :search_icon_image, dependent: :destroy
  has_one_attached :filter_icon_image, dependent: :destroy
  has_one_attached :filter_cross_icon_image, dependent: :destroy
  has_one_attached :nav_add_image, dependent: :destroy
  has_one_attached :tab_bar_image, dependent: :destroy
end
