docker run \
  --platform linux/amd64 \
  -e RPC_HTTP_URL="https://rpc.holesky.redstone.xyz" \
  -p 3001:3001  \
  ghcr.io/latticexyz/store-indexer:latest  \
  pnpm start:sqlite