# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association test
  it { is_expected.to belong_to(:coach) }
  it { is_expected.to have_many(:activities) }

  # Validation tests
  it { is_expected.to validate_presence_of(:name) }
end
