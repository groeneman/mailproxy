gateways = {
  'sendgrid' => ::SendgridMailer,
  'mailgun' => ::MailgunMailer
}

gatway_from_env = ENV.fetch('MAIL_GATEWAY', 'mailgun')

Rails.configuration.default_mail_gateway = gateways.fetch(gatway_from_env) do
  fail("Invalid mail gateway specified. Should be one of #{ gateways.keys }")
end
