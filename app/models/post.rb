require 'open-uri'
class Post < ApplicationRecord
  attr_accessor :tags_which_duplicate_tag
  before_create :check_act_as_taggable_record
  before_update :check_act_as_taggable_record
  # after_create_commit :add_image_variant
  # after_create_commit :compress

  scope :by_recently_created, -> (limit) { order(created_at: :desc).limit(limit) }
  scope :by_recently_updated, -> (limit) { order(updated_at: :desc).limit(limit) }
  after_create_commit { PostBadgeJob.perform_now(self) }

  belongs_to :user
  has_one_attached :post_image, dependent: :destroy

  has_one :post_image_attached, class_name: 'ActiveStorage::Attachment', as: :record
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :tournament_banner, optional: true

  acts_as_taggable_on :tags
  after_create_commit { PostBadgeJob.perform_now(self) }

  def period_count_array
    from = self.created_at.beginning_of_day.beginning_of_day
    to = Date.today.end_of_day
    self.where(created_at: from..to).group('date(created_at)').count
  end

  # def compress
  #   if self.post_image.present? && self.post_image.content_type[0...5] == "image"
  #     @image = self.post_image.variant(quality: 45).processed.url
  #     self.update(compress_image: @image)
  #   end
  # end

  # def self.compress_update(post)
  #   if post.post_image.present? && post.post_image.content_type[0...5] == "image"
  #     @image = post.post_image.variant(quality: 45).processed.url
  #     post.update(compress_image: @image)
  #   end
  # end

  def add_image_variant
    if post_image.attached? && post_image.content_type[0...5] == "image"
      image = URI.open(self.post_image.variant(quality: 45).processed.url)
      post_image.attach(io: image, filename: 'compressed')
    end
  end

  def self.add_image_variant_update(post)
    if post.post_image.attached? && post.post_image.content_type[0...5] == "image"
      image = URI.open(post.post_image.variant(quality: 45).processed.url)
      post.post_image.attach(io: image, filename: 'compressed')
    end
  end

  def check_act_as_taggable_record
    tag_list = []

    dup_arr = self&.tags_which_duplicate_tag&.split(",")
    if dup_arr.present?
      dup_value = dup_arr.map { |element| element if dup_arr.count(element) > 1 }
      tag_list = dup_arr.map { |element| element unless dup_arr.count(element) > 1 }
      last_value = ''
      dup_value&.compact&.each_with_index do |single_tag, index|
        tag_list << single_tag + "dup" + index.to_s if index != 0
        tag_list << single_tag if index == 0 || last_value == '' || last_value != single_tag
        last_value = single_tag
      end
      self.tag_list = tag_list.reject(&:blank?)
    end
  end

end
