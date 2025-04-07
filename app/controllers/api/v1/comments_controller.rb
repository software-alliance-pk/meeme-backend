require 'tempfile'
class Api::V1::CommentsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:create]
  before_action :find_comment, only: [:show, :update_comments, :destroy, :create_child_comment]
  before_action :find_child_comment, only: [:child_comments, :child_comment_destroy]

  def index
    @comments = Post.find_by(id: params[:post_id])
    if @comments.present?
      @comments = @comments.comments.where(parent_id: nil).order('created_at DESC').paginate(page: params[:page], per_page: 25)
      if @comments.present?
      else
      end
    else
      render json: { message: "Post is not present" }, status: :not_found
    end

  end

  def child_comments
    @child_comment = @child_comment.paginate(page: params[:page], per_page: 25)
    if @child_comment.present?

    else
    end

  end

  def show
    render json: { comment: @current_user.comments },
           status: :ok
  end

  def create
    # @comment = Post.find(params[:post_id]).comments.new(description: params[:description],
    #                                                     user_id: @current_user.id,
    #                                                     post_id: params[:post_id])
    # comment_image = params.delete(:comment_image)
    @comment = Post.find(params[:post_id]).comments.new(image_comments_params)
      # if comment_image.present?
      #   if comment_image.content_type == "image/heic" || comment_image.content_type == "image/heif"
      #     comment_blob = convert_heic_to_jpeg(comment_image) # Use the correct method for conversion
      #     if comment_blob.present? # Check if conversion was successful
      #       @comment.comment_image.attach(comment_blob) # Directly attach the converted blob
      #     end
      #   else
      #     @comment.comment_image.attach(comment_image) # Attach other image formats directly
      #   end
      # end
    @comment.user_id = @current_user.id
    if @comment.save
      if Post.find(params[:post_id]).user_id != @current_user.id
        Notification.create(title: "Comment",
                            body: "#{@current_user.username} commented on your post",
                            user_id: @comment.post.user.id,
                            notification_type: 'comment',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username,
                            post_id: params[:post_id]
                            )
      end
      render json: { comment: @comment, comment_image: @comment.comment_image.attached? ? (@comment.comment_image.variable? ? @comment.comment_image.blob.variant(resize_to_limit: [512, 512], quality: 50).processed.url : @comment.comment_image.blob.url) : '' }, status: :ok
    else
      render_error_messages(@comment)
    end
  end

  def create_child_comment
    # @comment = Post.find(params[:post_id]).comments.new(description: params[:description],
    #                                                     user_id: @current_user.id,
    #                                                     post_id: params[:post_id],
    #                                                     parent_id: params[:comment_id])
    # comment_image = params.delete(:comment_image)
    @comment = Post.find(params[:post_id]).comments.new(image_comments_params)
      # if comment_image.present?
      #   if comment_image.content_type == "image/heic" || comment_image.content_type == "image/heif"
      #     comment_blob = convert_heic_to_jpeg(comment_image) # Use the correct method for conversion
      #     if comment_blob.present? # Check if conversion was successful
      #       @comment.comment_image.attach(comment_blob) # Directly attach the converted blob
      #     end
      #   else
      #     @comment.comment_image.attach(comment_image) # Attach other image formats directly
      #   end
      # end
    @comment.user_id = @current_user.id
    @comment.parent_id = params[:comment_id]
    if @comment.save
      render json: { comment: @comment, comment_image: @comment.comment_image.attached? ? (@comment.comment_image.variable? ? @comment.comment_image.blob.variant(resize_to_limit: [512, 512], quality: 50).processed.url : @comment.comment_image.blob.url) : '' }, status: :ok
      if Post.find(params[:post_id]).user_id != @current_user.id
        Notification.create(title: "Comment",
                            body: "#{@current_user.username} commented on your post",
                            user_id: @comment.post.user.id,
                            notification_type: 'comment',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username,
                            post_id: params[:post_id]
                            )
      end
    else
      render_error_messages(@comment)
    end
  end

  # To update the single comment 
  def update_comments
    unless @comment.update(comment_params)
      render_error_messages(@comment)
    else
      @comment.update(comment_params)
      render json: { comment: @comment,
                     message: "Comment Updated" },
             status: :ok
    end
  end

  def update_child_comments
    @child_comment = Comment.find_by(id: params[:id])
    if @child_comment.present?
      unless @child_comment.update(comment_params)
        render_error_messages(@child_comment)
      else
        @child_comment.update(comment_params)
        render json: { child_comment: @child_comment,
                       message: "Child Comment Updated" },
               status: :ok
      end
    else
      return render json: { message: ' Child Comment Not found' }, status: :not_found
    end
  end

  def destroy
    @comment.destroy
    render json: { message: "Comment successfully destroyed" }, status: :ok
  end

  # To delete the child comments
  def child_comment_destroy
    @child_comment = Comment.find_by(id: params[:comment_id])
    if @child_comment.present?
      @child_comment.destroy
      render json: { message: "Child Comment successfully destroyed" }, status: :ok
    else
      render json: { message: "Child Comment not found" }, status: :not_found
    end
  end


  def convert_heic_to_jpeg(uploaded_file)
    begin
      Rails.logger.info "Starting HEIC to JPEG conversion..."

      # Create a temporary file for the HEIC input
      temp_heic = Tempfile.new(['image', '.heic'], binmode: true)
      temp_heic.write(uploaded_file.read)
      temp_heic.rewind
      Rails.logger.info "HEIC file written to temp path: #{temp_heic.path}"

      # Create a temporary file for the converted JPEG output
      temp_jpg = Tempfile.new(['image', '.jpg'], binmode: true)
      temp_jpg.close # Close it to avoid conflicts with ImageMagick
      Rails.logger.info "JPEG temp file created at: #{temp_jpg.path}"

      # Convert HEIC to JPEG using ImageMagick and log the output
      convert_command = "magick convert #{temp_heic.path}[0] #{temp_jpg.path}"
      if convert_command
        Rails.logger.info "ImageMagick conversion successful!"
      else
        Rails.logger.warn "ImageMagick failed, trying heif-convert..."
        system("heif-convert -q 100 #{temp_heic.path} #{temp_jpg.path}")
      end
      
      Rails.logger.info "Running command: #{convert_command}"

      convert_output = `#{convert_command} 2>&1`
      convert_status = $?.exitstatus
      Rails.logger.info "Conversion output: #{convert_output}"
      Rails.logger.info "Conversion exit status: #{convert_status}"

      # Check if the conversion failed
      if convert_status != 0
        Rails.logger.error "ImageMagick conversion failed!"
        raise "ImageMagick failed with status #{convert_status}: #{convert_output}"
      end

      # Ensure the converted file is valid
      unless File.exist?(temp_jpg.path) && File.size(temp_jpg.path) > 0
        Rails.logger.error "Converted JPEG file is empty or does not exist."
        raise "Converted JPEG file is empty or does not exist."
      end

      Rails.logger.info "Successfully converted HEIC to JPEG."

      # Upload the converted file to ActiveStorage
      converted_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(temp_jpg.path),
        filename: "#{SecureRandom.hex(10)}.jpg",
        content_type: "image/jpeg"
      )

      Rails.logger.info "Image uploaded successfully to ActiveStorage: #{converted_blob.filename}"

      converted_blob
    rescue => e
      Rails.logger.error "Error while converting HEIC: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    ensure
      # Cleanup temp files
      temp_heic.close! if temp_heic
      temp_jpg.close! if temp_jpg
      Rails.logger.info "Temp files cleaned up."
    end
  end

  private

  def find_post
    @post = Post.find_by(id: params[:post_id]).present?
    if @post
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end
  end

  def find_comment
    if Post.find_by(id: params[:post_id]).present?
      if Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).present?
        unless (@comment = Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]))
          return render json: { message: ' Comment Not found' }, status: :not_found
        end
      else
        return render json: { message: ' Comment not found' }, status: :not_found
      end
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end

  end

  def find_child_comment
    if Post.find_by(id: params[:post_id]).present?
      if Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).present?
        unless (@child_comment = Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).comments)
          return render json: { message: ' Child Comment Not found' }, status: :not_found
        end
      else
        return render json: { message: ' Comment not found' }, status: :not_found
      end
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end
  end

  def image_comments_params
    params.permit(:description, :post_id, :comment_image)
  end

  def comment_params
    params.permit(:id, :description, :comment_likes, :post_id, :user_id)
  end
end
