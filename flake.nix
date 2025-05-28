{
  description = "Scott's custom tools for OneBrief development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        tools = pkgs.stdenv.mkDerivation {
            name = "wscoble-tools";
            src = ./hack;
            installPhase = ''
                mkdir -p $out/bin
                cp $src/* $out/bin
            '';
        };
      in {
        defaultPackage = tools;
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ ]; };
    });
}
