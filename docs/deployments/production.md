# Deployment check list

- [ ] Deploy on Heroku?
  - [ ] Does `config/credentials/production.yml.enc` exist?
    - [ ] Is `RAILS_MASTER_KEY` env var properly defined?
  - [ ] Is postgres addon properly defined on a non-free version?
  - [ ] Is `DEFAULT_PASSWORD` properly defined?
  - [ ] Is `DEFAULT_LOCALE` properly defined?
  - [ ] Is `HOST` and `DOMAIN_NAME` properly defined?
  - [ ] If the registrar doesn't allow root redirection, is `ENABLE_ROOT_REDIRECT` properly defined?
  - [ ] Does the project use delay jobs?
    - [ ] Is the worker resource enabled?
  - [ ] Does the project uses action cables?
    - [ ] Is the Reddis addon properly added?
  - [ ] Does the project sends mails?
    - [ ] Is mailgun addon added?
    - [ ] Is mailgun addon configured?
    - [ ] Are `MAILGUN_*` env vars properly defined?
  - [ ] Does the project send sms?
    - [ ] Is Guard Static IP addon added?
    - [ ] Is Guard Static IP addon configured?
    - [ ] Are Guard Static IPs added in SMS provider admin?
    - [ ] Do `SMS_*` env vars have been specified?
  - [ ] Does the project uses a map?
    - [ ] Is `GOOGLE_MAP_KEY` env var properly defined?

- [ ] Deploy on OVH?
  - [ ] Does `./3print_games_ruby` file exist?
  - [ ] Is `RAILS_ENV` properly defined?
  - [ ] Is `DEFAULT_PASSWORD` properly defined?
  - [ ] Is `DEFAULT_LOCALE` properly defined?
  - [ ] Is `HOST` and `DOMAIN_NAME` properly defined?
  - [ ] IS `SECRET_KEY_BASE` properly defined?
  - [ ] Does `config/credentials/production.yml.enc` exist?
    - [ ] Is `RAILS_MASTER_KEY` env var properly defined?
  - [ ] Or does `config/credentials.yml.enc` exist on the server?
    - [ ] Is `master.key` file created on the server?
  - [ ] Does the project uses delay jobs?
    - [ ] Is the `daemon` gem added to the `Gemfile`?
  - [ ] Does the project send sms?
    - [ ] Does `SMS_*` env vars have been specified?
    - [ ] Is the server IP added in SMS provider admin?
  - [ ] Does the project send mails?
    - [ ] Are `MAILGUN_*` env vars properly defined?
  - [ ] Does the project use a map?
    - [ ] Is `GOOGLE_MAP_KEY` env var properly defined?
  - [ ] Does the project use Galec APIs?
    - [ ] Are `*.cer` and `*.key` files available?
    - [ ] Are `INFOMIL_*` env vars properly defined?
    - [ ] Are `CIAM_*` env vars properly defined?

- [ ] Is S3 Bucket created?
  - [ ] With proper CORS settings?
  - [ ] With proper ACL settings? (public-read most of the time)
  - [ ] Do `AWS_*` env vars have been specified?
  - [ ] Is `ASSET_HOST` env var properly defined?


