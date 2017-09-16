class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.2/pycairo-1.15.2.tar.gz"
  sha256 "a66f30c457736f682162e7b3a33bc5e8915c0f3b31ef9bdb4edf43c81935c914"

  bottle do
    cellar :any
    sha256 "4ee1296a4703769417f431ff0a88005bd6c9f260c08825c1796505312cfe4ea2" => :high_sierra
    sha256 "361deed1f8c10425d63cacd18250a47a01f878b6d069d8330638f3b503115021" => :sierra
    sha256 "c218b4f2d24763ef41c8846cfbbcdfd6ae3b6e08f65cef8e8fe78e5d4f67fbd9" => :el_capitan
    sha256 "bf72c2f548ca6d8336518c01673a611e65bda2f8accc594e1bc3149e138e25d3" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python3

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
