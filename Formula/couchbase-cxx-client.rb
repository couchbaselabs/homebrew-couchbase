class CouchbaseCxxClient < Formula
  desc "Couchbase C++ Client"
  homepage "https://github.com/couchbase/couchbase-cxx-client"
  url "https://packages.couchbase.com/clients/cxx/couchbase-cxx-client-1.5.1.tar.gz"
  sha256 "9112d1e34f68b4d9f00f397eec487b169a896f1337938f9a3661747947656a9b"
  license "Apache-2.0"
  head "https://github.com/couchbase/couchbase-cxx-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/couchbaselabs/couchbase"
    rebuild 11
    sha256 cellar: :any, arm64_golden_gate: "31a0eb1946f6d67c5969b2cfae6a72183025792d1234898807101f721616cb81"
    sha256 cellar: :any, arm64_tahoe:       "937aee678df68ad0ab6407b50e394ca002581016a28031b10b30da0cca520896"
    sha256 cellar: :any, arm64_sequoia:     "b899f817ad4a70a847c463ca405e8a84d0158f4096fe88c1f438e1acb6c9baa6"
  end

  depends_on "cmake" => :build
  depends_on "coreutils" => :build # gcp
  depends_on "findutils" => :build # gxattr
  depends_on "gnu-sed" => :build # gsed
  depends_on "gnu-tar" => :build # gtar
  depends_on "ninja" => :build

  conflicts_with "cbc", "libcouchbase", because: "both install `cbc` binaries"

  def install
    args = %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DCOUCHBASE_CXX_CLIENT_INSTALL=ON
      -DCOUCHBASE_CXX_CLIENT_STATIC_BORINGSSL=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_EXAMPLES=OFF
      -DCOUCHBASE_CXX_CLIENT_BUILD_TESTS=OFF
      -DCOUCHBASE_CXX_CLIENT_BUILD_OPENTELEMETRY=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_TOOLS=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_STATIC=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_SHARED=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_FIT_PERFORMER=ON
      -DCOUCHBASE_CXX_CLIENT_BUILD_COUCHBASE2=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    mv bin/"fit_performer", bin/"couchbase-cxx_fit_performer" if (bin/"fit_performer").exist?
  end

  test do
    system bin/"cbc", "--version"
  end
end
