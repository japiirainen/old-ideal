{
  description = "Ideal development environment.";

  inputs.zig2nix.url = "github:Cloudef/zig2nix";
  inputs.zls.url = "github:zigtools/zls";

  outputs = { zig2nix, zls, ... }:
    let
      flake-utils = zig2nix.inputs.flake-utils;
    in
    (flake-utils.lib.eachDefaultSystem (system:
      let

        env = zig2nix.outputs.zig-env.${system} { zig = zig2nix.outputs.packages.${system}.zig.master.bin; };
        system-triple = env.lib.zigTripleFromString system;
      in
      with builtins; with env.lib; with env.pkgs.lib; rec {
        # nix build .#target.{zig-target}
        # e.g. nix build .#target.x86_64-linux-gnu
        packages.target = genAttrs allTargetTriples (target: env.packageForTarget target ({
          src = cleanSource ./.;

          nativeBuildInputs = [ ];
          buildInputs = [ ];
          zigPreferMusl = true;
          zigDisableWrap = true;
        } // optionalAttrs (!pathExists ./build.zig.zon) {
          pname = "ideal";
          version = "0.0.0";
        }));

        packages.default = packages.target.${system-triple}.override {
          zigPreferMusl = false;
          zigDisableWrap = false;
        };

        apps.bundle.target = genAttrs allTargetTriples (target:
          let
            pkg = packages.target.${target};
          in
          {
            type = "app";
            program = "${pkg}/bin/master";
          });

        apps.bundle.default = apps.bundle.target.${system-triple};
        apps.default = env.app [ ] "zig build run -- \"$@\"";
        apps.build = env.app [ ] "zig build \"$@\"";
        apps.test = env.app [ ] "zig build test -- \"$@\"";
        apps.docs = env.app [ ] "zig build docs -- \"$@\"";
        apps.deps = env.showExternalDeps;

        devShells.default = env.mkShell {
          packages = [ zls.packages.${system}.zls ];
        };
      }));
}
