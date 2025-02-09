class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.3/E.tgz"
  sha256 "5366d2de77e6856250e26a967642389e81a6f823caedccaf5022a09242aceb96"

  bottle do
    cellar :any_skip_relocation
    sha256 "c281d0aebc16da93a003f2baf76cd3388f8458fba3cc88e38bc7556b54e1cdfd" => :catalina
    sha256 "464244b8f862c83abbf2b5969790af6f80fd26d21cd1b1d8c575b44c6c73c9ec" => :mojave
    sha256 "6f51683fc53c488f2d16fa3b6fab7ed30e7b4a6c99dd42331c29631120891c67" => :high_sierra
    sha256 "d18b5d1b173a6061bd90ecb590ce95ae864c562786376583d57029ce651060e4" => :sierra
    sha256 "e2549dc5ecf1fbe4895084b1b981a2e84041a289677b8204000b4b82d64cfad2" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
