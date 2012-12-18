require 'spec_helper'

describe ScheduledTransaction do
  describe 'associations' do
    it { should belong_to(:account) }
  end
end
