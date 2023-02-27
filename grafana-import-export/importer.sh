#!/usr/bin/env bash

KEY=""
HOST="https://throbbing-pond-c4bc.app.openiap.io"

for FILE in *; do
cat $FILE | jq '. * {overwrite: true, dashboard: {id: null}}' | curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer eyJrIjoic3VvUnJoTnNKYzdLT1lReER2cmQ4ampFRVEyT0VuR0IiLCJuIjoidGVzdCIsImlkIjoxfQ==" https://throbbing-pond-c4bc.app.openiap.io/api/dashboards/db -d @- ;
done

