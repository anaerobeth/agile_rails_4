class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  #analogous to
  #validates(:title, :description, :image_url, {:presence => true})

  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  #0.01 because of the precision of the database column - 0.001 would
  #technically be zero, but would pass a greater_than: 0 test

  validates :title, uniqueness: true

  #why allow_blank: true?  If we don't this validation and the presence validation
  #will both fire, giving two error messages when we really just want the
  #error from the presence validation.
  validates :image_url, allow_blank: true, format: {
    with: /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL for a GIF, JPG, or PNG image.'
  }

  #Let's try validating that the description is at least 10 chars
  validates :description, allow_blank: true, length: {
    minimum: 10,
    message: 'is too short - it must be at least 10 characters long'
  }

  def self.latest
    Product.order(:updated_at).last
  end

  private
  
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, "Line Items present")
        return false
      end
    end
  
end
