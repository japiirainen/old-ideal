.PHONY: cabal-fmt
cabal-fmt:
	cabal-fmt --inplace --Werror --indent 2 *.cabal
