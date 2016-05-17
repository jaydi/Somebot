module Ibiza
  class SomebotWorker

    ERROR_MSG = {
      account_id_parameter_needed: "카카오 아이디를 입력하세요.",
      user_exists: "이미 등록된 사용자",
      register_error: "등록실패:오류",
      register_needed: "등록 후 사용가능",
      target_id_parameter_needed: "상대방 카카오 아이디를 입력하세요.",
      arrow_exists: "이미 관심설정된 대상",
      arrow_not_exists: "관심설정 대상없음",
      already_not_interested: "이미 해제된 대상"
    }

    class << self

      def register(user, args)
        user.account_id = args[0]
        if user.account_id.blank?
          error_message(user, :account_id_parameter_needed)
        elsif user.registered? and user.active?
          error_message(user, :user_exists)
        elsif user.registered? and !user.active?
          user.reactivate!
          send_message(user, "등록완료")
        else
          user.save!
          send_message(user, "등록완료")
        end
      end

      def unregister(user)
        if user.registered? and user.active?
          user.deactivate!
          send_message(user, "탈퇴완료")
        else
          error_message(user, :register_needed)
        end
      end

      def arrow(user, args)
        target_id = args[0]
        if target_id.blank?
          error_message(user, :target_id_parameter_needed)
        elsif user.registered? and user.active?
          arrow = Arrow.where(origin: user.account_id, destination: target_id)[0]
          if !arrow.blank? and arrow.interested?
            error_message(user, :arrow_exists)
          elsif !arrow.blank? and arrow.was_interested?
            arrow.re_interest!
            send_message(user, "관심설정완료")
            check_arrow_match(user, arrow)
          else
            arrow = Arrow.new({origin: user.account_id, destination: args[0]})
            arrow.save!
            send_message(user, "관심설정완료")
            check_arrow_match(user, arrow)
          end
        else
          error_message(user, :register_needed)
        end
      end

      def unarrow(user, args)
        target_id = args[0]
        if target_id.blank?
          error_message(user, :target_id_parameter_needed)
        elsif user.registered? and user.active?
          arrow = Arrow.where(origin: user.account_id, destination: target_id)[0]
          if arrow.blank?
            error_message(user, :arrow_not_exists)
          elsif arrow.was_interested?
            error_message(user, :already_not_interested)
          else
            arrow.cancel_interest!
            send_message(user, "관심해제완료")
          end
        else
          error_message(user, :register_needed)
        end
      end

      def status_check(user)
        if user.registered? and user.active?
          sent_arrows = Arrow.where(origin: user.account_id, status: :interested)
          gotten_arrows_count = Arrow.where(destination: user.account_id, status: :interested).count

          msg = "#{user.account_id}\n\n"
          msg << "나의 관심 리스트\n"
          sent_arrows.each do |sa|
            msg << "#{sa.destination}\n"
          end
          msg << "\n"
          msg << "나에게 관심있는 사람\n"
          msg << "#{gotten_arrows_count}명"

          send_message(user, msg)
        else
          error_message(user, :register_needed)
        end
      end

      def help(user)
        send_message(user, '사용법')
      end

      private

      def check_arrow_match(user, arrow)
        target = User.where(account_id: arrow.destination)[0]
        if target.blank?
          send_message(user, "상대방은 아직 관심봇을 사용하지 않습니다.")
          return
        end

        send_message(target, "누군가 당신에게 관심을 보였습니다.")

        match = Arrow.where(origin: arrow.destination, destination: arrow.origin)[0]
        if match.blank?
          send_message(user, "상대방은 아직 당신에게 관심을 보이지 않았습니다.")
          return
        end

        if match.was_interested?
          send_message(user, "상대방은 지금 당신을 관심설정하지 않았습니다. 하지만 당신에게 관심을 가졌던 적이 있습니다.")
          send_message(target, "한때 당신이 관심을 가졌던 사람입니다.")
          return
        end

        if match.interested?
          send_message(user, "축하합니다. 상대방도 당신에게 관심이 있습니다.")
          send_message(target, "축하합니다. #{user.account_id}도 당신에게 관심을 보였습니다.")
          return
        end
      end

      def error_message(user, error)
        send_message(user, ERROR_MSG[error])
      end

      def send_message(user, msg)
        Ibiza::MessageSender.send(user, msg)
      end

    end

  end
end