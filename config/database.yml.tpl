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
  <<: *authentication
  database: db_development

test:
  <<: *connection
  <<: *authentication
  database: db_test

production:
  <<: *connection
  <<: *authentication
  database: db_production
