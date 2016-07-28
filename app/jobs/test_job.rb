class TestJob < ActiveJob::Base
  queue_as :default

  def perform(payment_id)
    Ibiza::HttpPersistent.post("https://www.metabot.tk/payments/#{payment_id}/callback", {}, Ibiza::HTTPHeaders::JSON)
  end
end
