class AvatarValidator
	extend ActiveModel::Naming
  extend ActiveModel::Callbacks

	include ActiveModel::Validations
	include Paperclip::Glue

	define_model_callbacks :save, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]  

	validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 1.megabytes, message: "Максимальний розмір аватару 1 мегабайт"
	has_attached_file :avatar

	# validates :avatar, file_size: { less_than: 1.megabytes }

  attr_accessor :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size

  def to_model
    self
  end
 
  # def valid?()      true end
  def new_record?() true end
  def destroyed?()  true end

  def errors
    obj = Object.new
    def obj.[](key)         [] end
    def obj.full_messages() [] end
    def obj.any?()       false end
    obj
  end  
end