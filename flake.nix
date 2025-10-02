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
        runtimeDeps = with pkgs; [
          gh
          kubernetes-helm
          awscli2
          kubectl
        ];
        tools = pkgs.stdenv.mkDerivation {
          name = "wscoble-tools";
          src = ./hack;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin
            cp $src/* $out/bin
            chmod +x $out/bin/*
            if [ -f $out/bin/patch-review-helm ]; then
              wrapProgram $out/bin/patch-review-helm \
                --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
            fi
          '';
        };
      in {
        defaultPackage = tools;
        devShell = pkgs.mkShell {
          buildInputs = runtimeDeps;
        };
      });
}
