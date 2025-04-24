# frozen_string_literal: true

class CouchbaseCxxClient < Formula
  desc "Couchbase C++ Client"
  homepage "https://github.com/couchbase/couchbase-cxx-client"
  url "https://packages.couchbase.com/clients/cxx/couchbase-cxx-client-1.0.7.tar.gz"
  sha256 "0b7b5fdf673fc37e496dd8b30668d0249e95fa5b781c53a60085aafadb35f9c6"
  license "Apache-2.0"
  head "https://github.com/couchbase/couchbase-cxx-client.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "findutils" => :build # gxattr
  depends_on "coreutils" => :build # gcp
  depends_on "gnu-tar" => :build # gtar
  depends_on "gnu-sed" => :build # gsed

  conflicts_with "cbc", "libcouchbase", because: "both install `cbc` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCOUCHBASE_CXX_CLIENT_INSTALL=ON",
           "-DCOUCHBASE_CXX_CLIENT_STATIC_BORINGSSL=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_EXAMPLES=OFF",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_TESTS=OFF",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_TOOLS=ON",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_STATIC=OFF",
           "-DCOUCHBASE_CXX_CLIENT_BUILD_SHARED=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/cbc", "--version"
  end
end
