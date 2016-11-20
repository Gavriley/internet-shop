class User < ActiveRecord::Base
  has_many :products
  has_many :comments, dependent: :destroy
  has_attached_file :avatar, styles: { full: "300x300>", comment: "100x100>" }

  belongs_to :role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation { login.strip!; name.strip! }

  validates :login, uniqueness: { message: "Логін вже використовується" }, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true, message: "В логіні присутні недопустимі символи" },
  	length: { maximum: 25, message: "Максимальний розмір логіна 25 символів" }, presence: { message: "Заповніть поле логін" }
  validates :name, length: { maximum: 50, message: "Максимальний розмір імені 50 символів" }, presence: { message: "Заповніть поле імя" }	

  validates_attachment :avatar, content_type: { content_type: ["image/jpeg", "image/png", "image/gif", "image/jpg"], message: "Некоректний формат аватару" }
  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 1.megabytes, message: "Максимальний розмір аватару 1 мегабайт" 

  after_initialize { self.role ||= Role.find_by_name("guest") }
  before_create { self.role = Role.find_by_name("client") }
end
