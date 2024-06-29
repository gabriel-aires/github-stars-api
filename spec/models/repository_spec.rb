require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe "#save!" do

    context "with valid parameters" do
      subject { described_class.new(name: "test", stars: 0, user: User.new(login: "test")) }

      it 'persists to database' do
        expect { subject.save! }.not_to raise_error
      end
    end

    context "with invalid parameters" do
      subject { described_class.new }

      it 'raises exception' do
        expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

  end
end
