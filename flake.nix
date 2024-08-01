{
  description = "Ideal development environment.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem =
        { config
        , self'
        , inputs'
        , pkgs
        , system
        , ...
        }:
        let
          inherit (pkgs) haskellPackages;
          inherit (haskellPackages) mkDerivation;
          name = "ideal";
          version = "0.1.0";
        in
        {
          devShells = {
            default = pkgs.mkShell {
              packages = with haskellPackages; [ cabal-fmt ];
              inputsFrom = [ self'.packages.default ];
              buildInputs = with pkgs; [ cabal-install ];
            };
          };
          packages = {
            ideal = mkDerivation {
              inherit version;
              description = "";
              license = "";
              pname = name;
              src = ./.;
            };
            default = self'.packages.ideal;
          };
        };
    };
}
