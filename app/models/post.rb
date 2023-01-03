class Post < ApplicationRecord
  attr_accessor :tags_which_duplicate_tag
  before_create :check_act_as_taggable_record
  before_update :check_act_as_taggable_record

  scope :by_recently_created, -> (limit) { order(created_at: :desc).limit(limit) }
  scope :by_recently_updated, -> (limit) { order(updated_at: :desc).limit(limit) }
  after_create_commit { PostBadgeJob.perform_now(self) }

  validates :description, presence: true

  belongs_to :user
  has_one_attached :post_image, dependent: :destroy
  has_one :post_image_attached,class_name: 'ActiveStorage::Attachment',as: :record
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

  def check_act_as_taggable_record
    tag_list = []

    dup_arr = self&.tags_which_duplicate_tag&.split(",")
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
