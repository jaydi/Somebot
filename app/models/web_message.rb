class WebMessage < ActiveRecord::Base

  enum bound: {
    inbound: 10,
    outbound: 20
  }

  def process_message
    user = current_user
    case command
      when '등록'
        Ibiza::SomebotWorker.register(user, args)
      when '탈퇴'
        Ibiza::SomebotWorker.unregister(user)
      when '관심설정'
        Ibiza::SomebotWorker.arrow(user, args)
      when '관심해제'
        Ibiza::SomebotWorker.unarrow(user, args)
      when '체크'
        Ibiza::SomebotWorker.status_check(user)
      when '전달'
        Ibiza::SomebotWorker.deliver_message(user, args)
      when '질문'
        Ibiza::SomebotWorker.ask_question(user, args)
      else
        Ibiza::SomebotWorker.help(user)
    end
  end

  private

  def current_user
    current_user = User.find_by_user_key(user_key)
    if current_user.blank?
      current_user = User.new({ user_key: user_key, last_msg_id: msg_id, last_chat_key: chat_key })
    else
      current_user.last_msg_id = msg_id
      current_user.last_chat_key = chat_key
      current_user.save!
    end
    current_user
  end

  def command
    @params ||= text.split(' ')
    @command ||= @params[0]
    @command
  end

  def args
    @params ||= text.split(' ')
    @args ||= @params.drop(1)
    @args
  end

  def msg
    @params ||= text.split(' ')
    @args ||= @params.drop(2)
    @msg = @args.join(' ')
    @msg
  end

end
