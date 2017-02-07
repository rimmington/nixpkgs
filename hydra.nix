{nixpkgs ? <nixpkgs>, systems ? [ "armv7l-linux" ]}:

let lib = (import nixpkgs {}).lib;
in lib.genAttrs systems (system:
let pkgs = import nixpkgs { inherit system; };
in {
  inherit (pkgs.haskell.compiler) ghc801;
}
)
