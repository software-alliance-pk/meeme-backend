require 'tempfile'
require 'securerandom'
class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:destroy]

  def index
    @user = User.find_by(id: params[:user_id])
    
    if @user.present?
      @posts = @user.posts.where(tournament_meme: false).sort_by(&:created_at).reverse
      @posts_count = @posts.count.to_i
      # @posts = @posts.by_recently_created(200)
      
        if params[:month].present?
          @posts = @posts.where("EXTRACT(MONTH FROM created_at) = ?", params[:month].to_i).sort_by(&:created_at).reverse
          @posts_count = @posts.count.to_i
        else
          @posts_count = @posts.count.to_i
      end
        if params[:page].present?
        if params[:per_page].present? 
          @posts = @posts.paginate(page: params[:page], per_page: params[:per_page].to_i).sort_by(&:created_at).reverse
        elsif
          @posts = @posts.paginate(page: params[:page], per_page: 16).sort_by(&:created_at).reverse
        end
      end
  
      if @posts.any?
        # Respond with the posts (assuming a view or serializer is in place)
      else
       @posts = []
      end
    else
      render json: { message: "User not found" }, status: :not_found
    end
  end
  

  def show
    @post = Post.find_by(id: params[:id])  
    unless @post
      render json: { message: "Post not found" }, status: :not_found
    end
  end

  def create
    @post = @current_user.posts.new(post_params)
    @post.tags_which_duplicate_tag = params[:tag_list]
    thumbnail = ''
    if @post.save
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      if @post.post_image.attached? || @post.post_image.video?
        if @post.post_image.video?
          # Generate a thumbnail for the video
          if params[:thumbnail].present?
            thumbnail_blob = ActiveStorage::Blob.create_and_upload!(
              io: params[:thumbnail], # Use 'open' to get the file object
              filename: params[:thumbnail].original_filename,
              content_type: params[:thumbnail].content_type
            )
            thumbnail = thumbnail_blob.variant(resize_to_limit: [512, 512],quality:50).processed.url
            @post.video_thumbnail.attach(thumbnail_blob)
          else
            thumbnail_blob = generate_video_thumbnail(@post.post_image)
            thumbnail = thumbnail_blob.url
            @post.video_thumbnail.attach(thumbnail_blob)
          end
        end
        # if @post.post_image
        #   video_preview = @post.compress
        #   # thumbnail = video_preview.processed.url if video_preview.processed.present?
        # end
        @post.update(duplicate_tags: @tags, thumbnail: thumbnail)
      else
        @post.update(duplicate_tags: @tags)
      end
      render json: { user: @post.attributes.except('tag_list'), post_image: @post.post_image.attached? ? @post.post_image.blob.url : '', post_type: @post.post_image.content_type,thumbnail: @post.video_thumbnail.attached? ? @post.video_thumbnail.blob.url : thumbnail, message: 'Post created successfully' }, status: :ok
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
            system("ffmpeg -i #{thumbnail_path} -ss 1 -vframes 1 -f image2 #{thumbnail_output_path}")
  
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
          thumbnail_blob = nil
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
        thumbnail_blob = nil
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      thumbnail = nil # Indicate that an error occurred
      thumbnail_blob = nil
    end
  
    thumbnail_blob
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
    puts "updating post"
    puts "params #{params}"
    @post = Post.find_by(id: 3260)
    puts "post #{@post}"
    unless @post
      render json: { error: "Post not found" }, status: :not_found
      return
    end
  
    unless @post.update(update_post_params)
      render_error_messages(@post)
    else
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      @post.update(duplicate_tags: @tags) if @tags.present?
  
      if params[:tag_list] == "[]"
        @post.update(duplicate_tags: [])
      end
  
      render json: { 
        post: @post.attributes.except('tag_list'),
        message: "Post Updated" 
      }, status: :ok
    end
  end


  # def update_posts
  #   @post.tags_which_duplicate_tag = params[:tag_list]
  #   unless @post.update(post_params)
  #     render_error_messages(@post)
  #   else
  #     @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
  #     @post.update(post_params)
  #     # Post.add_image_variant_update(@post)
  #     @post.update(duplicate_tags: @tags) if @tags.present?
  #     if params[:tag_list] == "[]"
  #       @tags = []
  #       @post.update(duplicate_tags: @tags)
  #     end
  #     if params[:post_image].present?
  #       if params[:post_image].content_type[0..4]=="video"
  #         @post.update(thumbnail: @post.post_image.preview(resize_to_limit: [100, 100]).processed.url)
  #       else
  #         @post.update(thumbnail: nil)
  #       end
  #     end
  #     render json: { post: @post.attributes.except('tag_list'),
  #                    post_image: @post.post_image.attached? ? @post.post_image.blob.url : '',
  #                    post_type: @post.post_image.content_type,
  #                    message: "Post Updated" },
  #            status: :ok
  #   end
  # end

  def destroy
    @post.destroy
    render json: { message: "Post successfully deleted" }, status: :ok
  end
  def destroy_multiple

    post_ids = params[:post_ids]
    deleted_posts = []

    post_ids.each do |post_id|
      post = Post.find_by(id: post_id)
      if post.present? 
        post.destroy if post.tournament_meme == false
        post.update(deleted_by_user: true) if post.tournament_meme == true
        deleted_posts << post_id
      end
    end

    render json: { message: "Posts #{deleted_posts.join(', ')} successfully deleted" }, status: :ok
  end

  def explore
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    @posts = []
    blocked_user_ids = @current_user.blocked_users.pluck(:blocked_user_id)
    if params[:tag] == ""
      # Post.where(tournament_meme: false).by_recently_created(200).each do |post|
      #   if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
      #   else
      #     @posts << post
      #   end
      # end
      @posts = Post.includes(:user).where(tournament_meme: false)
             .where.not(user_id: blocked_user_ids)
             .where.not('flagged_by_user @> ARRAY[?]::integer[]', [@current_user.id])
             .where(users: { private_account: false })
             .by_recently_created(200)  
    else
      # Post.tagged_with(params[:tag], :any => true).each do |post|
      #   if post.flagged_by_user.include?(@current_user.id) || @current_user.blocked_users.pluck(:blocked_user_id).include?(post.user.id)
      #   else
      #     @posts << post
      #   end
      # end
      @posts = Post.includes(:user).tagged_with(params[:tag], any: true)
              .where.not(user_id: blocked_user_ids)
              .where.not('flagged_by_user @> ARRAY[?]::integer[]', [@current_user.id])
              .where(users: { private_account: false })
    end
      if @posts.present?
        if params[:per_page].present? 
        @posts = @posts.paginate(page: params[:page], per_page: params[:per_page].to_i)
      elsif
        @posts = @posts.paginate(page: params[:page], per_page: 25)
        end
    else
      render json: { message: "No Post found against this tag " }, status: :not_found
    end
  end

  def user_search_tags
    @recent_posts = []
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    if params[:tag] == ""
      @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
      if @users.present?
      end
    elsif params[:tag] == "#"
      @recent_posts = Post.where(tournament_meme: false).where(users: { private_account: false })
      @users = []

    else
      @recent_posts = Post.tagged_with(params[:tag], :any => true)
      if @recent_posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def search_tags_trending_post
    @trending_posts = []
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
    if params[:tag] == ""
      @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
      if @users.present?
      end
    elsif params[:tag] == "#"
      @trending_posts = Post.where(tournament_meme: false).where(users: { private_account: false })
      @users = []

    else
      @trending_posts = Post.tagged_with(params[:tag], :any => true)
      if @trending_posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def post_search_user_and_tag
    @posts = []
    @tags = ActsAsTaggableOn::Tag.where.not(taggings_count: 0).pluck(:name).map { |item| item.split("dup").first }.uniq
  
    if params[:tag].blank? && params[:username].blank?
      render json: { message: "Tag or Username parameter is required" }, status: :bad_request
      return
    end
  
    # Fetch posts based on tag
    # Post Controller comment
    if params[:tag].present?
      tag_posts = Post.tagged_with(params[:tag], any: true).includes(:user)
      .where(users: { private_account: false })
      @posts.concat(tag_posts)
    end
  
    # Fetch posts based on username
    if params[:username].present?
      @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").where(private_account: false)
      if @users.present?
        @users.each do |user|
          user_posts = user.posts
          @posts.concat(user_posts)
        end
      end
    end
  
    # Ensure @posts is unique
    @posts.uniq!
  
    # Paginate @posts  
    if @posts.present?
      @posts = @posts.paginate(page: params[:page], per_page: 25)
    else
      render json: { message: "No Post found" }, status: :not_found
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
    # Debugging: inspect the SQL query
    sql_query = ActsAsTaggableOn::Tag.joins(:taggings)
                                     .joins("INNER JOIN posts ON posts.id = taggings.taggable_id AND taggings.taggable_type = 'Post'")
                                     .where('posts.id IS NOT NULL')
                                     .where('taggings_count > 0')
                                     .group('tags.id', 'tags.name')
                                     .having('COUNT(posts.id) > 0')
                                     .limit(25)
                                     .to_sql
    
    puts sql_query  # Print the SQL query for debugging
  
    # Fetch tags associated with existing posts
    @tags = ActsAsTaggableOn::Tag.joins(:taggings)
                                 .joins("INNER JOIN posts ON posts.id = taggings.taggable_id AND taggings.taggable_type = 'Post'")
                                 .where('posts.id IS NOT NULL')
                                 .where('taggings_count > 0')
                                 .group('tags.id', 'tags.name')
                                 .having('COUNT(posts.id) > 0')
                                 .limit(25)
                                 .pluck('tags.name')
  
    # Process tags
    @tags = @tags.map { |item| item.split("dup").first }
                 .uniq
                 .first(250)
  
    render json: { tags: @tags }, status: :ok
  end
  

  def following_posts
    @following = Follower.where(follower_user_id: @current_user.id, 
                               is_following: true, 
                               status: ["following_added", "follower_added"]).pluck(:user_id)
    
    # Build base query with includes and where conditions
    user_posts = Post.includes(:user)
                     .where(user_id: @following, 
                           tournament_meme: false)
                     .where.not('flagged_by_user @> ARRAY[?]::integer[]', [@current_user.id])
                     .where.not(user_id: @current_user.blocked_users.pluck(:blocked_user_id))
                     .order(created_at: :desc)

    # Apply created_at filter if present
    if params[:created_at].present?
      created_at = Time.zone.parse(params[:created_at]) rescue nil
      if created_at
        user_posts = user_posts.where('posts.created_at <= ?', created_at)
      else
        render json: { message: "Invalid created_at format" }, status: :bad_request and return
      end
    end

    # Paginate results
    @following_posts = params[:per_page].present? ? 
      user_posts.paginate(page: params[:page], per_page: params[:per_page]) : 
      user_posts.paginate(page: params[:page], per_page: 10)

    if @following_posts.present?
      # Existing view will handle the response
    else
      render json: { following_posts: [], following_count: @following.length }, status: :ok
    end
  end

  def recent_posts
    @recent_posts = []
    blocked_user_ids = @current_user.blocked_users.pluck(:blocked_user_id)
    
    # Check if 'created_at' parameter is present and valid
    if params[:created_at].present?
      created_at = Time.zone.parse(params[:created_at]) rescue nil
      if created_at
        @recent_posts = Post.includes(:user)
          .where(tournament_meme: false)
          .where.not(user_id: blocked_user_ids)
          .where.not('flagged_by_user @> ARRAY[?]::integer[]', [@current_user.id])
          .where(users: { private_account: false })
          .where('posts.created_at <= ?', created_at) # Specify the table for created_at
          .by_recently_created(500)
      else
        render json: { message: "Invalid created_at format" }, status: :bad_request and return
      end
    else
      # Default behavior when 'created_at' is not provided
      @recent_posts = Post.includes(:user)
        .where(tournament_meme: false)
        .where.not(user_id: blocked_user_ids)
        .where.not('flagged_by_user @> ARRAY[?]::integer[]', [@current_user.id])
        .where(users: { private_account: false })
        .by_recently_created(500)
    end

    # Paginate the results
    @recent_posts = params[:per_page].present? ? @recent_posts.paginate(page: params[:page], per_page: params[:per_page]) : @recent_posts.paginate(page: params[:page], per_page: 25)
  end

  def trending_posts
    @trending_posts = []

    # Fetch likes and associated post_ids in a single query
    likes = Like.where(status: 1, is_liked: true, is_judged: false)
                .joins(:post)
                .where(posts: { tournament_meme: false })
                .group(:post_id)
                .count

    # Preload posts and users in a single query
    post_ids = likes.keys
    posts = Post.includes(:user, :comments)
                .where(id: post_ids)
                .where.not(user_id: @current_user.blocked_users.pluck(:blocked_user_id))
                .where(users: { private_account: false })
                .reject { |post| post.flagged_by_user.include?(@current_user.id) }

    # Calculate trending score for each post (likes + comments * 2)
    @trending_posts = posts.map do |post|
      score = likes[post.id].to_i + (post.comments.count * 2)
      [post, score]
    end

    # Sort posts by total score in descending order
    @trending_posts = @trending_posts.sort_by { |_, score| -score }

    # Paginate the results
    @trending_posts = if params[:per_page].present?
      @trending_posts.paginate(page: params[:page], per_page: params[:per_page].to_i)
    else
      @trending_posts.paginate(page: params[:page], per_page: 10)
    end
  end
  

  def share_post
    @share_post = Post.find_by(id: params[:post_id])
    if @share_post.present?
      if @share_post.tournament_meme
        render json: { message: 'Tournament Posts cannot be shared', post: [], share_count: @share_post.share_count }, status: :ok
      else
        @current_user.increment(:shared).save
        count = @share_post.share_count + 1
        @share_post.update_columns(share_count: count)
        ShareBadgeJob.perform_now(@share_post, @current_user)
        render json: { message: 'Tournament Posts Shared', post: @share_post, share_count: @share_post.share_count }, status: :ok
      end
    else
      render json: { message: 'Post not found' }, status: :not_found
    end
  end

  def increase_explore_count
    @current_user.increment!(:explored)
    ExploreBadgeJob.perform_now( @current_user)
    render json: { message: 'Exploration successful', explored_count: @current_user.explored }, status: :ok
  end
  

  def create_downloadable_link
    image_url = params[:image_url]
    downloaded_image = open(image_url)
    temp_file = Tempfile.new(['image', '.jpg'])
    temp_file.binmode
    temp_file.write(downloaded_image.read)
    temp_file.rewind
    send_file temp_file, filename: 'downloaded_image.jpg', disposition: 'attachment'
        temp_file.close
    temp_file.unlink
    rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def current_user_tournament_posts
    @user_tournament_post = params[:page].present? ? @current_user.posts.where(tournament_meme: true, deleted_by_user: false).by_recently_created(200).paginate(page: params[:page], per_page: 25).shuffle : @current_user.posts.where(tournament_meme: true, deleted_by_user: false).by_recently_created(200)
    unless @user_tournament_post.present?
      render json: { message: "No tournament posts for this particular user" }, status: :not_found
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

  def update_post_params
    params.permit(:post_id, :description, :tag_list)
  end

end
