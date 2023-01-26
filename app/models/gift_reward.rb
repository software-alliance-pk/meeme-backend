class GiftReward < ApplicationRecord
  enum status: { OnStock: 0, Awarded: 1}
end