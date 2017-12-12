class User < ActiveRecord::Base

  has_secure_password
  has_many :reviews
  validates :name, presence: true
  validates :email, presence: true, :uniqueness => {:case_sensitive => false}
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  before_save :downcase_email

  def downcase_email
    self.email.downcase!
  end

  def self.authenticate_with_credentials(email, password)
    @authenticated_user = User.where("email = ?", email.strip.downcase).first
    if @authenticated_user && @authenticated_user.authenticate(password)
      @authenticated_user
    else
      nil
    end
  end

end