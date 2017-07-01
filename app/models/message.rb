class Message
  include ActiveModel::Model

  # Simple regex for validating emails from http://emailregex.com/
  EMAIL_VALIDATION_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_accessor :to, :to_name, :from, :from_name, :subject, :body

  validates :to_name, :from_name, :subject, :body, presence: true
  validates :to, :from, format: {
    with: EMAIL_VALIDATION_REGEX,
    message: "must be an email address"
  }
end
