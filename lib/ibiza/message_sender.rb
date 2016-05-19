module Ibiza
  class MessageSender

    class << self

      def body(user, msg)
        params = {
          msg_id: user.last_msg_id.to_i,
          chat_key: user.last_chat_key.to_i,
          msg_type: 'text',
          text: msg
        }
        params.to_json
      end

      def header
        headers = {}
        headers.merge!(Ibiza::HTTPHeaders::JSON)
        headers.merge!(Ibiza::HTTPHeaders::AUTH)
        headers
      end

      def send(user, msg)
        if Rails.env.sandbox? or Rails.env.production?
          res = Ibiza::HttpPersistent.post("#{APP_CONFIG[:api_base_url]}/#{APP_CONFIG[:bot_id]}/send_message", body(user, msg), header)
          case res.status
            when 200
            when 400
              res.error = {code: res.status, msg: "잘못된 요청 (bot_id, json format)"}
            when 401
              res.error = {code: res.status, msg: "잘못된 액세스 토큰"}
            when 405
              res.error = {code: res.status, msg: "잘못된 HTTP Method (not POST)"}
            when 408
              res.error = {code: res.status, msg: "타임아웃"}
          end
          res
        else
          puts header
          puts body(user, msg)
        end
      end

    end

  end
end