{
  description = "Ideal development environment.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          toolchain = pkgs.rustPlatform;
        in
        rec
        {
          packages.ideal =
            toolchain.buildRustPackage {
              pname = "ideal";
              version = "0.0.1";
              src = ./.;
              cargoLock.lockFile = ./Cargo.lock;
            };

          packages.default = packages.ideal;

          apps.default = flake-utils.lib.mkApp { drv = packages.default; };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # nix
              nixpkgs-fmt
              # rust
              (with toolchain; [
                cargo
                rustc
                rustLibSrc
                rust-analyzer
                clippy
                rustfmt
              ])
            ];

            RUST_SRC_PATH = "${toolchain.rustLibSrc}";
          };
        }
      );
}
