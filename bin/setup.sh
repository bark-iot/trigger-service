#!/bin/bash
docker-compose run trigger-service bundle
docker-compose run trigger-service ./cli db_migrate
cd ../trigger-service/docs && mkdocs build # build api doc