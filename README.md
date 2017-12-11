# trigger-service

See `bark` repository for instructions.

# API docs
- to view go to [http://localhost/triggers/docs](http://localhost/triggers/docs)
- to build run `cd docs && mkdocs build`

# Migrations
- `docker-compose run trigger-service ./cli db_migrate`

# Run tests
- `dc run trigger-service rspec`