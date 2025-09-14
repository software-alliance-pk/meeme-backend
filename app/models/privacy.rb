class Privacy < ApplicationRecord
  audited
  has_rich_text :body
end
