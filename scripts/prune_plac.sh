#!/bin/sh

echo "=== Pruning plac Docker resources ==="

# 1. Stop and remove any plac containers
echo "Stopping and removing plac containers..."
containers=$(docker ps -aq --filter "name=plac")
if [ -n "$containers" ]; then
  docker rm -f $containers
else
  echo "No plac containers found."
fi

# 2. Remove networks created for plac
echo "Removing plac networks..."
networks=$(docker network ls -q --filter "name=plac")
if [ -n "$networks" ]; then
  docker network rm $networks 2>/dev/null || true
fi

# Remove default compose networks if present
for net in current_default nginx_default apache_default small_default tiny_default; do
  if [ -n "$(docker network ls -q --filter "name=^${net}$")" ]; then
    docker network rm "$net" 2>/dev/null || true
  fi
done

# 3. Remove custom plac images (leaves base images cached and untouched)
echo "Removing custom plac images..."
plac_images=$(docker images --filter "reference=plac-*" --format "{{.Repository}}:{{.Tag}}")
if [ -n "$plac_images" ]; then
  docker rmi $plac_images
else
  echo "No custom plac images found."
fi

echo "=== Done! All plac items cleaned. ==="
