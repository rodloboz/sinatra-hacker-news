# frozen_string_literal: true

class Post < ActiveRecord::Base
  belongs_to :user

  # TODO: Copy-paste your code from previous exercise
  validates :user, presence: true

  validates :name, presence: true,
                   length: { minimum: 5 },
                   uniqueness: { 
                     case_sensitive: false
                   }

  validates :url, presence: true,
                  format: { with: %r{https?://.*} }
  
  delegate :username, to: :user

  def upvote!
    increment!(:votes)
  end

  def downvote!
    decrement!(:votes)
  end
end
