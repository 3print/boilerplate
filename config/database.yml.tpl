connection: &connection
  adapter:  postgresql
  host:     localhost
  encoding: unicode
  pool:     5

authentication: &authentication
  username: USERNAME
  password: PASSWORD

development:
  <<: *connection
  # <<: *authentication
  database: PROJECT_NAME_development

test:
  <<: *connection
  # <<: *authentication
  database: PROJECT_NAME_test

production:
  <<: *connection
  <<: *authentication
  database: PROJECT_NAME_production
