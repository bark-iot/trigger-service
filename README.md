# device-service

See `bark` repository for instructions.

# API docs
- to view go to [http://localhost/devices/docs](http://localhost/devices/docs)
- to build run `cd docs && mkdocs build`

# Migrations
- `docker-compose run device-service ./cli db_migrate`

# Run tests
- `dc run device-service rspec`