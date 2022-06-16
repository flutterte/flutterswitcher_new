# This script creates/updates pub-credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${PUB_DEV_PUBLISH_ACCESS_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_ACCESS_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_REFRESH_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_REFRESH_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_ID_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_ID_TOKEN environment variable"
  exit 1
fi

#if [ -z "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" ]; then
  #echo "Missing PUB_DEV_PUBLISH_TOKEN_ENDPOINT environment variable"
 # exit 1
#fi

#if [ -z "${PUB_DEV_PUBLISH_EXPIRATION}" ]; then
  # exit 1
#fi

# Create pub-credentials.json file.
mkdir ~/.config
mkdir ~/.config/dart

cat <<EOF > ~/.config/dart/pub-credentials.json
{
  "accessToken": "${PUB_DEV_PUBLISH_ACCESS_TOKEN}",
  "refreshToken": "${PUB_DEV_PUBLISH_REFRESH_TOKEN}",
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU4MGFkYjBjMzJhMTc1ZDk1MGExYzE5MDFjMTgyZmMxNzM0MWRkYzQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiODE4MzY4ODU1MTA4LThncmQyZWc5dGo5ZjM4b3M2ZjF1cmJjdnNxMzk5dThuLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiODE4MzY4ODU1MTA4LThncmQyZWc5dGo5ZjM4b3M2ZjF1cmJjdnNxMzk5dThuLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAzMDE3MDY5MTAxODQxNzUwMzA4IiwiZW1haWwiOiJxc3NxNTIxQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoibzNqX2tkZFc5MENLOFN5M3hTZ085QSIsImlhdCI6MTY1NTI4OTYzMywiZXhwIjoxNjU1MjkzMjMzfQ.OvXjZui_KPG_OM6KFDalcJ4KZE87I3t53CRWmtU_bi642ZBXmoAlZFm-QdZhpg7mzMo-W7qw39nRNrfkYyLH1TRNHwqKNyL29UnfrXagN-nQjRmnO5eS_JrsQWhWr0CGsuPyaewBC4WSE8CYPz3YtBEtCllvVq5jwx_Pj2kPpEfLuHrDoFpK2b8PH1jLRWMPbv3-mJb8XCOvvbY0-UbHrawWW53ntl46zE49Hgb-fby_Re071iIDWkLy-EPv2X2GpXUVKgjjwc5Osa63uMQRqmuFrkCyWN2ZFcihOwMfR7w4KC6c-pRy20Ed9LcEDjWR7NwZu-FseOWNE371PgzwmA",
  "tokenEndpoint": "https://accounts.google.com/o/oauth2/token",
  "scopes": ["https://www.googleapis.com/auth/userinfo.email", "openid"],
  "expiration": 1655293221820
}