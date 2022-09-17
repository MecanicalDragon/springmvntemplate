#!/bin/sh


curl -X POST "http://localhost:9100/post-any" \
-H "Content-Type: application/json" \
--data "@wiremock/req/req1.json" -v

curl -X GET "http://localhost:9100/get-by-id/478" -H "Content-Type: application/json" -v