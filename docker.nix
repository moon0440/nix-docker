{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildLayeredImage {
  name = "nix-container";
  tag = "latest";
  created = "now";
  contents = with pkgs; [
    neovim
    ripgrep
    gh
    nodePackages.npm
    python3
    kustomize
    kubernetes-helm
    kubectl
    bashInteractive
  ];
}

