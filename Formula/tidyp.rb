class Tidyp < Formula
  desc "Validate and modify HTML"
  homepage "http://tidyp.com/"
  url "https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz"
  sha256 "20b0fad32c63575bd4685ed09b8c5ca222bbc7b15284210d4b576d0223f0b338"

  bottle do
    cellar :any
    sha256 "ed67353f58e09c04387453c92536d7980c3408391bae0db77f3af421779cee57" => :catalina
    sha256 "234868d17b7ca6e890d0adc4e339e2a35c81b3c72f0fd8487d1d3352b03fddc5" => :mojave
    sha256 "52ef5e1d78ef5a3404e2345683fc03a61b0fad8084b74508473a042b1858b54c" => :high_sierra
    sha256 "6b5b65c1476004cc973fff0992dfaf77887b5a5df583ac31fc22665d250b538a" => :sierra
    sha256 "5274bb4cd33d9c15d8c73dbe4cfb54e686da29cd29093adba549024fe520b82c" => :el_capitan
    sha256 "710962782d909bf11987f8b147d7e141ccba48643ab2db02c7f267d6cf871dd9" => :yosemite
    sha256 "7501f78d5f8e549fec7f689cd24aafa716e2097744ec78359d8092183469e4c8" => :mavericks
    sha256 "a67e93cc14f51fd0ed5668b04f7c7de13c679d3713ea1fa236f35fc7f9f10674" => :x86_64_linux # glibc 2.19
  end

  depends_on "libxslt" => :build unless OS.mac?

  resource "manual" do
    url "https://raw.githubusercontent.com/petdance/tidyp/6a6c85bc9cb089e343337377f76127d01dd39a1c/htmldoc/tidyp1.xsl"
    sha256 "68ea4bb74e0ed203fb2459d46e789b2f94e58dc9a5a6bc6c7eb62b774ac43c98"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Use the newly brewed tidyp to generate the manual
    resource("manual").stage do
      system "#{bin}/tidyp -xml-help > tidyp1.xml"
      system "#{bin}/tidyp -xml-config > tidyp-config.xml"
      xsltproc_dir = OS.mac? ? "/usr/bin/" : Formula["libxslt"].bin
      system "#{xsltproc_dir}/xsltproc tidyp1.xsl tidyp1.xml > tidyp.1"
      man1.install gzip("tidyp.1")
    end
  end

  test do
    system "#{bin}/tidyp", "--version"
  end
end
