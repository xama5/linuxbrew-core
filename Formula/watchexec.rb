class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.10.3.tar.gz"
  sha256 "2bbef078d3937764cfb063c6520eae5117eddb5cfd15efabc39a69fc69b9989e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ac159612e527bef2cc0cabdfd6eeef19263d0faba224371a63f4fdb568d2219" => :catalina
    sha256 "b09275b1c686404ea57e8c0b52c9f2f52b06bc9cbd6b61935e50ca280e902c1c" => :mojave
    sha256 "9bbda6ac49cb30495ec20ed084d08b636a526578a3ec1df8c7e6948c9b7105dc" => :high_sierra
    sha256 "eda530af03c418d4adbd80ae33922d4912df3eae4ecb5695c4692a21d4cc9af5" => :sierra
    sha256 "0227c1728a9cb23308088ad72505bebce16d8acd36dad5af95309c1eb7f7364f" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    line = "saw file change"
    Utils.popen_read("#{bin}/watchexec", "--", "echo", line) do |o|
      assert_match line, o.readline.chomp
      Process.kill("INT", o.pid)
    end
  end
end
