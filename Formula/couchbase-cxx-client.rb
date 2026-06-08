# frozen_string_literal: true

class CouchbaseCxxClient < Formula
  desc "Couchbase C++ Client"
  homepage "https://github.com/couchbase/couchbase-cxx-client"
  url "https://packages.couchbase.com/clients/cxx/couchbase-cxx-client-1.3.2.tar.gz"
  sha256 "b2c82548c48dcf2481ec0bac4ad9c24a93324e5e74e31ddd566731527cce4187"
  license "Apache-2.0"
  head "https://github.com/couchbase/couchbase-cxx-client.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "findutils" => :build # gxattr
  depends_on "coreutils" => :build # gcp
  depends_on "gnu-tar" => :build # gtar
  depends_on "gnu-sed" => :build # gsed

  depends_on "protobuf" => :build
  depends_on "curl" => :build
  depends_on "nlohmann-json" => :build

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
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/cbc", "--version"
  end
end
