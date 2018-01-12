#!/bin/bash
docker-compose run trigger-service bundle
docker-compose run trigger-service ./cli db_migrate
docker-compose run trigger-service bundle exec ./cli db_seed
cd ../trigger-service/docs && mkdocs build # build api doc