class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    include RatingAverage

    def to_s
        "%s - %s" % [self.name, self.brewery.name]
    end
end
