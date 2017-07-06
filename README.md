# Mailproxy

A simple app that sends email messages through a third party gateway. Sendgrid and Mailgun are currently supported.

## Installation

### Locally

Requirements: Ruby 2.4.0 (other Ruby 2.x versions likely work, but haven't been tested), Bundler

1. Clone the project
2. `bundle`
3. `bundle exec rails s`

### On Heroku

Requirements: [Heroku Toolbelt](https://devcenter.heroku.com/articles/heroku-cli)

1. `heroku apps:create <your app name here>`
2. `heroku config:set SENDGRID_API_KEY=<your Sendgrid API key> MAILGUN_ENDPOINT=<your mailgun endpoint>`
3. `git push heroku master`

## API

Mailproxy exposes an `/email` endpoint that responds to `POST` requests and accepts the following parameters (all required):

- `to` The email address to send to.
- `to_name` The name to accompany the email
- `from` The email address in the from and reply fields
- `from_name` The name to accompany the from/reply emails
- `subject` The subject line of the email
- `body` The HTML body of the email (will be converted to plain text before sending)

### Example API Call

```http
POST /emails

{
  "to": "fake@example.com",
  "to_name": "Mr. Fake",
  "from": "noreply@fakecorp.com",
  "from_name": "Fake Corp Billing",
  "subject": "A Message from Fake Corporation",
  "body": "<h1>Your Bill</h1><p>$10</p>"
}```

If the parameters are valid and Mailproxy is able to deliver the message, it will respond with `200 OK` (with no response body). If the parameters were invalid, it will respond with `400 Bad Request` with an array of `errors`. If the parameters were valid but Mailproxy received an error from the gateway, it will respond with `500 Internal Server Error`, along with an array of `errors` that can assist in troubleshooting the gateway.

## Changing mail gateway

Mailproxy is designed to allow the mail gateway provider to be changed quickly in the event of an outage. The gateway can be set using the `MAIL_GATEWAY` environment variable to either `sendgrid` or `mailgun`. If `MAIL_GATEWAY` is not set, Mailgun will be used by default.

## Adding additional gateways

Additional mail gateways can be supported by creating a class that responds to the following methods:

- `#initialize` takes a `Message` object (described below).
- `#call` delivers the message
- `#ok?` returns true if the message was delivered, false otherwise
- `#errors` returns an array of errors from the gateway if the message was note delivered.

The `Message` object responds to methods named exactly the same as the API parameters, as well as an additional `sanitized_body` method that returns the body as plain text.

In order to set a new mail gateway as the default using the `MAIL_GATEWAY` environment variable, the new gateway needs to be registered in `config/initializers/mail_gateway.rb`.

## Design

### Frameworks and Packages

Mailproxy is a Rails 5 API-only application. Rails is probably overkill for this project, but I chose to use it anyway because of my familiarity with the framework. Working with a solid framework that I know well allowed me to complete the project as quickly as possible. To reduce the footprint of the default Rails app, I removed several default gems (including ActiveRecord) that weren't necessary for this project.

I tried to stick with default Ruby/Rails functionality for simplicity's sake, including for converting HTML to plain text. I did however add the [RestClient](https://github.com/rest-client/rest-client) Gem, as Ruby's default `Net::HTTP` feels unnecessarily verbose and complex to me. I used RSpec for testing, again due to my existing familiarity.

### Future Work

There are a few possible areas for future work:

- API monitoring: check the status of the Sendgrid and Mailgun APIs automatically (either by pinging a status page, or by monitoring the rates of 500-series errors being returned to Mailproxy) and failover automatically.
- After adding a few more gateways, evaluate the pattern used in the `MailgunMailer` and `SendgridMailer` and adjust based on experience implementing several new mailing services.
- Automatic detection of new mail gateway implementations so that `config/initializers/mail_gateway.rb` is no longer needed.
