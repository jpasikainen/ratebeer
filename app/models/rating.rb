class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        "teksti"
    end
end
