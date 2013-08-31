class Product < ActiveRecord::Base
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
end
