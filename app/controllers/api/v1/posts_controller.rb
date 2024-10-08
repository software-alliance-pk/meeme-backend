require 'tempfile'
require 'securerandom'
class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:show, :update_posts, :destroy]

  def index
    @posts = @current_user.posts.by_recently_created(20).paginate(page: params[:page], per_page: 25).shuffle
    if @posts.present?

    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def show
    render json: { post: @current_user.posts.by_recently_created },
           status: :ok
  end

  def create
    @post = @current_user.posts.new(post_params)
    @post.tags_which_duplicate_tag = params[:tag_list]
    if @post.save
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      if @post.post_image.attached? || @post.post_image.video?
        thumbnail = ''
        if @post.post_image.video?
          # Generate a thumbnail for the video
          thumbnail = generate_video_thumbnail(@post.post_image)
        end
        if @post.post_image
          video_preview = @post.compress
          # thumbnail = video_preview.processed.url if video_preview.processed.present?
        end
        @post.update(duplicate_tags: @tags, thumbnail: thumbnail)
      else
        @post.update(duplicate_tags: @tags)
      end
      render json: { user: @post.attributes.except('tag_list'), post_image: @post.post_image.attached? ? @post.post_image.blob.url : '', post_type: @post.post_image.content_type, message: 'Post created successfully' }, status: :ok
    else
      render_error_messages(@post)
    end
  end

  
  def generate_video_thumbnail(video_attachment)
    thumbnail = ''
  
    begin
      # Check if FFmpeg is available
      if system('ffmpeg -version > /dev/null 2>&1')
  
        begin
          # Generate a random unique filename for the thumbnail
          thumbnail_filename = "thumbnail_#{SecureRandom.hex(16)}.jpg"
          thumbnail_path = File.join('/tmp', thumbnail_filename)
          video_blob = video_attachment.blob
  
          # Check if the video_blob content is nil
          if video_blob.nil?
            puts "Error: Video content is nil."
            thumbnail = nil # Indicate that an error occurred
          else
            # Download the video blob content to the tempfile
            File.open(thumbnail_path, 'wb') do |thumbnail_file|
              thumbnail_file.write(video_blob.download)
            end
  
            # Generate the thumbnail using FFmpeg with a unique output filename
            thumbnail_output_filename = "thumbnail_#{SecureRandom.hex(16)}.jpg"
            thumbnail_output_path = File.join('/tmp', thumbnail_output_filename)
            system("ffmpeg -i #{thumbnail_path} -ss 5 -vframes 1 -f image2 #{thumbnail_output_path}")
  
            # Check if the generated thumbnail path contains null bytes
            if thumbnail_output_path.include?("\x00")
              puts "Error: Thumbnail path contains null byte."
              thumbnail = nil # Indicate that an error occurred
            else
              thumbnail_blob = ActiveStorage::Blob.create_and_upload!(io: File.open(thumbnail_output_path), filename: "thumbnail.jpg")
              thumbnail = thumbnail_blob.url
            end
          end
        rescue StandardError => e
          puts "Error while generating video thumbnail: #{e.message}"
          thumbnail = nil # Indicate that an error occurred
        ensure
          # Delete both temporary files after processing
          File.delete(thumbnail_path) if File.exist?(thumbnail_path)
          File.delete(thumbnail_output_path) if File.exist?(thumbnail_output_path)
        end
      else
        puts "FFmpeg is not available or there was an error."
        # Handle the case where FFmpeg is not available
        # You might want to log an error or use a default thumbnail
        thumbnail = nil # Indicate that an error occurred
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      thumbnail = nil # Indicate that an error occurred
    end
  
    thumbnail
  end
  

  # def generate_video_thumbnail(video_attachment)
  #   thumbnail = ''
  
  #   begin
  #     # Check if FFmpeg is available
  #     if system('C:\\ffmpeg-2023-09-07-git-9c9f48e7f2-essentials_build\\bin\\ffmpeg.exe -version > NUL 2>&1')
  
  #       begin
  #         # Generate a random unique filename for the thumbnail
  #         thumbnail_filename = "thumbnail_#{SecureRandom.hex(16)}.jpg"
  #         thumbnail_path = File.join('C:/Temp', thumbnail_filename)
  #         video_blob = video_attachment.blob
  
  #         # Check if the video_blob content is nil
  #         if video_blob.nil?
  #           puts "Error: Video content is nil."
  #           thumbnail = nil # Indicate that an error occurred
  #         else
  #           # Download the video blob content to the tempfile
  #           File.open(thumbnail_path, 'wb') do |thumbnail_file|
  #             thumbnail_file.write(video_blob.download)
  #           end
              
  #           # Generate the thumbnail using FFmpeg with a unique output filename
  #           thumbnail_output_filename = "thumbnail_#{SecureRandom.hex(16)}.jpg"
  #           thumbnail_output_path = File.join('C:/Temp', thumbnail_output_filename)
  #           system("C:\\ffmpeg-2023-09-07-git-9c9f48e7f2-essentials_build\\bin\\ffmpeg.exe -i #{thumbnail_path} -ss 5 -vframes 1 -f image2 #{thumbnail_output_path}")
  
  #           # Check if the generated thumbnail path contains null bytes
  #           if thumbnail_output_path.include?("\x00")
  #             puts "Error: Thumbnail path contains null byte."
  #             thumbnail = nil # Indicate that an error occurred
  #           else
  #             thumbnail_blob = ActiveStorage::Blob.create_and_upload!(io: File.open(thumbnail_output_path), filename: "thumbnail.jpg")
  #                           thumbnail = thumbnail_blob.url
  #           end
  #         end
  #       rescue StandardError => e
  #         puts "Error while generating video thumbnail: #{e.message}"
  #         thumbnail = nil # Indicate that an error occurred
  #       ensure
  #         # Delete both temporary files after processing
  #         # File.delete(thumbnail_path) if File.exist?(thumbnail_path)
  #         # File.delete(thumbnail_output_path) if File.exist?(thumbnail_output_path)
  #       end
  #     else
  #       puts "FFmpeg is not available or there was an error."
  #       # Handle the case where FFmpeg is not available
  #       # You might want to log an error or use a default thumbnail
  #       thumbnail = nil # Indicate that an error occurred
  #     end
  #   rescue StandardError => e
  #     puts "Error: #{e.message}"
  #     thumbnail = nil # Indicate that an error occurred
  #   end
  
  #   thumbnail
  # end
  
  
  

  def update_posts
    @post.tags_which_duplicate_tag = params[:tag_list]
    unless @post.update(post_params)
      render_error_messages(@post)
    else
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      @post.update(post_params)
      # Post.add_image_variant_update(@post)
      @post.update(duplicate_tags: @tags) if @tags.present?
      if params[:post_image].present?
        if params[:post_image].content_type[0..4]=="video"
          @post.update(thumbnail: @post.post_image.preview(resize_to_limit: [100, 100]).processed.url)
        else
          @post.update(thumbnail: nil)
        end
      end
      render json: { post: @post.attributes.except('tag_list'),
                     post_image: @post.post_image.attached? ? @post.post_image.blob.url : '',
                     post_type: @post.post_image.content_type,
                     message: "Post Updated" },
             status: :ok
    end
  end

  def destroy
    @post.destroy
    render json: { message: "Post successfully deleted" }, status: :ok
  end

  def explore
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    @posts = []
    if params[:tag] == ""
      Post.where(tournament_meme: false).by_recently_created(25).each do |post|
        if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
        else
          @posts << post
        end
      end
      if @posts.present?
        @posts = @posts.paginate(page: params[:page], per_page: 25)
      else
        # @posts=Post.all.paginate(page: params[:page], per_page: 25)
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    else
      Post.tagged_with(params[:tag], :any => true).each do |post|
        if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
        else
          @posts << post
        end
      end
      if @posts.present?
        @posts = @posts.paginate(page: params[:page], per_page: 25)
      else
        # @posts=Post.all.paginate(page: params[:page], per_page: 25)
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def user_search_tag
    @posts = []
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    if params[:tag].empty?
      @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
      if @users.present?
      end
    elsif params[:tag] == "#"
      @posts = Post.where(tournament_meme: false)
      @users = []

    else
      @posts = Post.tagged_with(params[:tag], :any => true)
      if @posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end

  end

  def other_posts
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).uniq
    @post = Post.find_by(id: params[:post_id])
    @all_posts = []
    if params[:tag] == "#"
      Post.where(tournament_meme: false).each do |post|
        if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
        else
          @all_posts << post
        end
      end
    else
      @posts = Post.tagged_with(params[:tag])
      @posts = @posts.where.not(id: @post.id) unless @post.nil?
      @posts.each do |post|
        if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
        else
          @all_posts << post
        end
      end
      if @all_posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    if @tags.present?
      render json: { tags: @tags }, status: :ok
    else
      render json: { tags: [] }, status: :ok
    end
  end

  def following_posts
    @following_posts = []
    @following = Follower.where(follower_user_id: @current_user.id , is_following: true).pluck(:user_id)
    @following = User.where(id: @following).paginate(page: params[:page], per_page: 25)
    @following.each do |user|
      user.posts.where(tournament_meme: false).each do |post|
        if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
        else
          @following_posts << post
        end
      end
    end
    @following_posts = @following_posts.shuffle
    if @following_posts.present?
    else
      render json: { following_posts: [], following_count: @following.count}, status: :ok
    end
  end

  def recent_posts
    @recent_posts = []
    Post.where.not(tournament_meme: true).by_recently_created(25).each do |post|
      if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
      else
        @recent_posts << post
      end
    end
    @recent_posts = @recent_posts.paginate(page: params[:page], per_page: 25)
    # @recent_posts = Post.where.not(tournament_meme: true).by_recently_created(25).paginate(page: params[:page], per_page: 25)
    # @today_post = Post.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where.not(tournament_meme: true).by_recently_created(25).paginate(page: params[:page], per_page: 25)
    # @random_posts = Post.where.not(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where.not(tournament_meme: true).paginate(page: params[:page], per_page: 25).shuffle
    # @recent_posts = @today_post + @random_posts
    # @recent_posts = Post.where(tournament_meme: false).by_recently_created(20).paginate(page: params[:page], per_page: 25).shuffle
  end

  def trending_posts
    @trending_posts = []
    @likes = Like.where(status: 1, is_liked: true, is_judged: false).joins(:post).where(post: { tournament_meme: false }).group(:post_id).count(:post_id).sort_by(&:last).reverse.to_h
    @likes.keys.each do |key|
      @post = Post.find_by(id: key)
      if @post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(@post.user.id)
      else
        @trending_posts << [@post, (Post.find_by(id: key).comments.count + Post.find_by(id: key).comments.count)]
      end
    end
    @trending_posts = (@trending_posts.to_h).sort_by { |k, v| v }.reverse.paginate(page: params[:page], per_page: 25)
    # @trending_posts=@trending_posts.paginate(page: params[:page], per_page: 25)
    # @trending_posts = Post.where(id: @likes.keys).paginate(page: params[:page], per_page: 25)
    if @trending_posts

    end
  end

  def share_post
    @share_post = Post.find_by(id: params[:post_id])
    if @share_post.present?
      if @share_post.tournament_meme == true
        render json: { message: 'Tournament Posts cannot be shared', post: [], share_count: @share_post.share_count }, status: :ok
      else
        count = @share_post.share_count + 1
        @share_post.update_columns(share_count: count)
        ShareBadgeJob.perform_now(@share_post, @current_user)
        render json: { message: 'Tournament Posts Shared', post: @share_post, share_count: @share_post.share_count }, status: :ok
      end
    else
      render json: { message: 'Post not found' }, status: :not_found
    end

  end

  private

  def find_post
    unless (@post = @current_user.posts.find_by(id: params[:post_id]))
      return render json: { message: 'Post Not found' }
    end
  end

  def post_params
    params.permit(:id, :description, :tag_list, :post_likes, :post_image, :user_id, :tournament_banner_id, :tournament_meme, :duplicate_tags, :share_count, :thumbnail,:compress_image)
  end
end
