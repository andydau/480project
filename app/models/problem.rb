class Problem < ActiveRecord::Base
    belongs_to :user
    has_many :attempts
end
