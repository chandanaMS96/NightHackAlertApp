class Developer < ApplicationRecord

  belongs_to :team
  validates :full_name, presence: true, length: { maximum: 20,  message: "title can have maximum 20 char"}
  validates :mobile, presence: true, length: { minimum: 10,  message: "mobile should have minimun 10 numbers"}
  validates :email, presence: true,  uniqueness: { message: "email %{value} already exists"}
  validate :validate_email_pattern

  def validate_email_pattern
    email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    errors.add(:email, "Enter valid email") unless self.email.match(email_regex)
  end

end
