{ cabal, safecopy, syb, sybWithClass }:

cabal.mkDerivation (self: {
  pname = "ixset";
  version = "1.0.5";
  sha256 = "1hznn7f8f13x5125n76dchayi16z72050qbwifnkrca54nf9q2ns";
  buildDepends = [ safecopy syb sybWithClass ];
  meta = {
    homepage = "http://happstack.com";
    description = "Efficient relational queries on Haskell sets";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
