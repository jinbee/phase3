class ConfirmMailer < ApplicationMailer

    def confirm_mail(confirm)
     @confirm = confirm

     mail to: confirm['mail'], subject: "投稿確認メール"

    end

end
