# frozen_string_literal: true

class CouchbaseCxxClient < Formula
  desc "Couchbase C++ Client"
  homepage "https://github.com/couchbase/couchbase-cxx-client"
  url "https://packages.couchbase.com/clients/cxx/couchbase-cxx-client-1.4.0.tar.gz"
  sha256 "dec07ee09de2446ef2a95eb22bf5da3f9299aa72662d9eed3f473d276b546538"
  license "Apache-2.0"
  head "https://github.com/couchbase/couchbase-cxx-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/couchbaselabs/couchbase"
    rebuild 6
    sha256 cellar: :any, arm64_sequoia: "1d59f8b1f09fe37d2b7014acadb18b876cf1b3cecb0ff8fe55427867bb319ab8"
    sha256 cellar: :any, arm64_sonoma:  "86b2bf67c12781493ddc028cac01c5178cc4b169e0bcd6cf888c3645f5c8df01"
  end

  depends_on "cmake" => :build
  depends_on "coreutils" => :build # gcp
  depends_on "findutils" => :build # gxattr
  depends_on "gnu-sed" => :build # gsed
  depends_on "gnu-tar" => :build # gtar
  depends_on "ninja" => :build

  conflicts_with "cbc", "libcouchbase", because: "both install `cbc` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-G", "Ninja",
           "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
           "-DCOUCHBASE_CXX_CLIENT_INSTALL=ON",
           "-DCOUCHBASE_CXX_CLIENT_STATIC_BORINGSSL=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_EXAMPLES=OFF",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_TESTS=OFF",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_OPENTELEMETRY=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_TOOLS=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_STATIC=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_SHARED=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_FIT_PERFORMER=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_COUCHBASE2=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    mv bin/"fit_performer", bin/"couchbase-cxx_fit_performer" if (bin/"fit_performer").exist?
  end

  test do
    system "#{bin}/cbc", "--version"
  end
end
