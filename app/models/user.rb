# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :posts

  # TODO: Copy-paste your code from previous exercise
  validates :username, presence: true,
                       uniqueness: true

  validates :email, presence: true,
                    format: { with: /.*@.*\..*/ }

  # TODO: Add some callbacks
  before_validation :strip_email, if: :email?

  private

  def strip_email
    self.email = email.strip
  end
end
