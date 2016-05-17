class Arrow < ActiveRecord::Base
  include AASM

  enum status: {
    interested: 10,
    was_interested: 20
  }

  aasm column: :status, enum: true do
    state :interested, initial: true
    state :was_interested

    event :cancel_interest do
      transitions from: :interested, to: :was_interested
    end

    event :re_interest do
      transitions from: :was_interested, to: :interested
    end
  end

end
