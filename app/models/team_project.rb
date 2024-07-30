# frozen_string_literal: true

class TeamProject < ApplicationRecord
  belongs_to :team
  belongs_to :project
end
