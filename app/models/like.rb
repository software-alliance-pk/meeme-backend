class Like <ApplicationRecord
  belongs_to :post,optional: true
  belongs_to :comment ,optional: true
  belongs_to :story ,optional: true
  belongs_to :user
  enum :status, [ :nil, :like, :dislike ]

end