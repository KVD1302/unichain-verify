#!/bin/sh

echo "generating env-config file"
workingDir="$nginx_dir"/html

echo "window._env_ = {" > "${workingDir}"/env.config.js
# strip CR characters from .env (handles Windows line endings), then parse
sed 's/\r$//' "${workingDir}"/.env | awk -F '=' '{
    key = $1
    value = substr($0, index($0, "=") + 1)
    # trim whitespace from key and value
    gsub(/^ +| +$/, "", key)
    gsub(/^ +| +$/, "", value)
    # escape embedded double quotes in value
    gsub(/\"/, "\\\"", value)
    print key ": \"" (ENVIRON[key] ? ENVIRON[key] : value) "\"," 
}' >> "${workingDir}"/env.config.js
echo "}" >> "${workingDir}"/env.config.js

echo "generation of env-config file completed!"

exec "$@"
