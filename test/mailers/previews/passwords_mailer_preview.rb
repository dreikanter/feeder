# Preview all emails at http://localhost:3000/rails/mailers/passwords_mailer
class PasswordsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/passwords_mailer/reset
  # :reek:UtilityFunction
  def reset
    PasswordsMailer.reset(User.take)
  end
end
