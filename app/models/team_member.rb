# frozen_string_literal: true

class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
