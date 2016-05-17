class User < ActiveRecord::Base
  include AASM

  enum status: {
    active: 10,
    deactivated: 20
  }

  aasm column: :status, enum: true do
    state :active, initial: true
    state :deactivated

    event :deactivate do
      transitions from: :active, to: :deactivated
    end

    event :reactivate do
      transitions from: :deactivated, to: :active
    end

  end

  def registered?
    !id.blank?
  end

end
