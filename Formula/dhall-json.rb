require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.4.1/dhall-json-1.4.1.tar.gz"
  sha256 "f70ef4d4c34624e761e339977a01d7cac0b0bbef228231d25f46729ddfdd2df2"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 "31afa844765b1abc4d50cd64426e8c0b5c35b5b5e912cf1a4170c1a1884f5545" => :mojave
    sha256 "49188890f01ff3ab6ff9d373f8a3e6c9346642f345fa63cdcee5409050eeea3d" => :high_sierra
    sha256 "f4f05b08e94e0d3df8b48885b69c9ce9678f84d9791af0e10ee6d12335ecb992" => :sierra
    sha256 "ff38cfd5ab654a76839a1995ed54d8b39d7a3fbfa9ba7d0e7ab916351cdb05f2" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
