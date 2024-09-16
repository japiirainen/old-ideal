.PHONY: check
check:
	@nix develop . --command cargo check

.PHONY: build
build:
	@nix develop . --command cargo build

.PHONY: run
run:
	@nix develop . --command cargo run

.PHONY: test
test:
	@nix develop . --command cargo test

.PHONY: fmt
fmt:
	@nix develop . --command cargo fmt

.PHONY: fmt-check
fmt-check:
	@nix develop . --command cargo fmt --check

.PHONY: clippy
clippy:
	@nix develop . --command cargo clippy -- --deny warnings

.PHONY: nixpkgs-fmt
nixpkgs-fmt:
	@nix develop . --command nixpkgs-fmt .

.PHONY: nixpkgs-fmt-check
nixpkgs-fmt-check:
	@nix develop . --command nixpkgs-fmt --check .
