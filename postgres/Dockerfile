FROM postgres:16-alpine

# Copiem fișierele SQL în imaginea PostgreSQL
# Vor fi rulate automat la prima pornire
COPY ../db/schema.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY ../db/seed.sql   /docker-entrypoint-initdb.d/02_seed.sql