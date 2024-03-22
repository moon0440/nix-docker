nix-build docker.nix -o result
docker load -i result
docker run -it nix-container:latest bash
