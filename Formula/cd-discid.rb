class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  revision 2
  head "https://github.com/taem/cd-discid.git"

  stable do
    url "http://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # macOS fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9f85136e9727175a4d861f759236d62cf24f19170e27bfd9bf8aeddbc4c8b3" => :catalina
    sha256 "158d91563b2e79574c0a336f775b49033d85ce3b290f122dae853dea45841f5b" => :mojave
    sha256 "26b88be0312f960484625161d94adf9a44aa88ef5817ba28b61af520a6e17e03" => :high_sierra
    sha256 "6b0d9c55a1adfce8a2c6e9eabd00c37118a05b60678564e7a9695d876bca117b" => :sierra
    sha256 "f0c17cfc3c345c661104a6f29562b766cac2a80747feea0c26cda04ece3c8326" => :el_capitan
    sha256 "3331be095997a1e5e6acb9f82f5e5473ed51c0f35976229371dc1d0c703c2e3b" => :yosemite
    sha256 "86f0066d344a2a0a37e3c00d08255d4a505b41cc2c38e7d33ac643d16af8ad71" => :mavericks
    sha256 "0eb2e3c44b9ba6f98ce5c5e34eca8ee576d3283b109dcbb0974bafc652a6c625" => :x86_64_linux # glibc 2.19
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end

__END__
diff --git a/cd-discid.c b/cd-discid.c
index 9b0b40a..2c96641 100644
--- a/cd-discid.c
+++ b/cd-discid.c
@@ -93,7 +93,7 @@
 #define cdth_trk1               lastTrackNumberInLastSessionLSB
 #define cdrom_tocentry          CDTrackInfo
 #define cdte_track_address      trackStartAddress
-#define DEVICE_NAME             "/dev/disk1"
+#define DEVICE_NAME             "/dev/rdisk1"

 #else
 #error "Your OS isn't supported yet."
@@ -236,8 +236,7 @@ int main(int argc, char *argv[])
	 * TocEntry[last-1].lastRecordedAddress + 1, so we compute the start
	 * of leadout from the start+length of the last track instead
	 */
-	TocEntry[last].cdte_track_address = TocEntry[last - 1].trackSize +
-		TocEntry[last - 1].trackStartAddress;
+TocEntry[last].cdte_track_address = htonl(ntohl(TocEntry[last-1].trackSize) + ntohl(TocEntry[last-1].trackStartAddress));
 #else   /* FreeBSD, Linux, Solaris */
	for (i = 0; i < last; i++) {
		/* tracks start with 1, but I must start with 0 on OpenBSD */
@@ -260,12 +259,12 @@ int main(int argc, char *argv[])
	/* release file handle */
	close(drive);

-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__DragonFly__) || defined(__APPLE__)
	TocEntry[i].cdte_track_address = ntohl(TocEntry[i].cdte_track_address);
 #endif

	for (i = 0; i < last; i++) {
-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__DragonFly__) || defined(__APPLE__)
		TocEntry[i].cdte_track_address = ntohl(TocEntry[i].cdte_track_address);
 #endif
		cksum += cddb_sum((TocEntry[i].cdte_track_address + CD_MSF_OFFSET) / CD_FRAMES);
