class DeleteStoryJob < Struct.new(:id)

  def perform
    @story = Story.find_by(id: id)
    if @story.present?
      @story.destroy
    end
  end
end