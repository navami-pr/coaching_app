# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Coach, type: :model do
  # Association test
  it { is_expected.to have_one(:course) }
  # Validation tests
  it { is_expected.to validate_presence_of(:name) }

  describe '.transfer_coach' do
    let!(:coaches) { create_list(:coach, 2) }
    let!(:coach) { coaches.last }
    let!(:course) { create(:course, coach: coach) }

    it 'tranfer the course to another coach' do
      allow(described_class).to receive_message_chain(:first, :course)
      expect(coach.transfer_coach).to eq([true, course])
    end
  end
end
