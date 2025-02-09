class CurlOpenssl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.66.0.tar.bz2"
  sha256 "6618234e0235c420a21f4cb4c2dd0badde76e6139668739085a70c4e2fe7a141"

  bottle do
    sha256 "2b28a8ee69e76187811d91d30a249227565530a39835774fde5f9b833d545e1d" => :catalina
    sha256 "48f2ce8c1ad64e221740f893e82b71511c4715283dc663128ad744f2ffa569f2" => :mojave
    sha256 "a93f3fe64c64afa6d3ffedaccfb1d3afc5f933ee475dc5a57e91ca151d05fc7a" => :high_sierra
    sha256 "fd3deb1cc6de9f34a727cfa545891bd56818595872f46b5c305435d234f77620" => :sierra
    sha256 "05139397c9d50a9f5682bc3d323a26072cbfd473a9cf3f083e416f0044fe75a6" => :x86_64_linux
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if OS.mac?
    keg_only :provided_by_macos
  else
    keg_only "it conflicts with curl"
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "libidn"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-ares=#{Formula["c-ares"].opt_prefix}
      --with-ca-bundle=#{etc}/openssl@1.1/cert.pem
      --with-ca-path=#{etc}/openssl@1.1/certs
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-libpsl
    ]

    system "./configure", *args
    system "make", "install"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
