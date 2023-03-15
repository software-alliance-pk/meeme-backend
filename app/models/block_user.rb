class BlockUser < ApplicationRecord
  belongs_to :blocked_by, :class_name=>'User'
  belongs_to :blocked_user, :class_name=>'User'
end