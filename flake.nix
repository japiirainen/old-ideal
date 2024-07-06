{
  description = "Ideal dev environment.";

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
          name = "ideal";
          version = "0.0.1";
        in
        {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ self'.packages.default ];
            packages = with pkgs; [ gtest ];
          };

          packages =
            let
              ideal = pkgs.stdenv.mkDerivation {
                inherit version;
                pname = name;
                src = ./.;

                buildInputs = with pkgs; [ cmake ];

                configurePhase = ''
                  cmake .
                '';

                buildPhase = ''
                  make
                '';

                installPhase = ''
                  mkdir -p $out/bin
                  mv ideal $out/bin/${name}
                '';
              };

              unit-tests = pkgs.stdenv.mkDerivation {
                inherit version;
                pname = "unit-tests";
                src = ./.;

                buildInputs = with pkgs; [ cmake gtest ];

                configurePhase = '''';

                buildPhase = ''
                  cmake --build . --target unit_tests
                '';

                installPhase = ''
                  mkdir -p $out/bin
                  mv unit_tests $out/bin/unit-tests
                '';
              };
            in
            {
              inherit ideal;
              inherit unit-tests;
              default = ideal;
            };
        };
    };
}
