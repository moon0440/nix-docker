{
  inputs = {
    docker-nixpkgs = {
      url = "github:nix-community/docker-nixpkgs";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, docker-nixpkgs, flake-utils, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      buildImageWithNix = import ("${docker-nixpkgs}" + "/images/nix/default.nix");
    in rec {
      packages.nixImage = buildImageWithNix {
        # All of this is required by the function
        inherit (pkgs)
          dockerTools
          bashInteractive
          cacert
          coreutils
          curl
          gnutar
          gzip
          iana-etc
          nix
          openssh
          xz;

        # We are actually going to use Git so we use the full version.
        gitReallyMinimal = pkgs.git;

        extraContents = with pkgs; [
          # Since we need git in this image let's add git-lfs right away.
          git-lfs
        ];
      };

      packages.default = pkgs.dockerTools.buildImage {
        fromImage = packages.nixImage;
        # ...
      };
    };
}


