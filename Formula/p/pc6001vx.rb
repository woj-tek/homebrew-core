class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.4_src.tar.gz"
  sha256 "0c9e565e6181e671c1f499808d9ca73b50a9b49e4b0633198f294b0d1076cf08"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "901a5a51a383ceea0c028af283c3bfdceaeb123e8f8f99bd7546902fa1243f24"
    sha256 cellar: :any,                 arm64_ventura:  "0ee9f1581e3f9aa34d71b0a6b6e876eb4cc8a5d4da0112b7dc1720066522847e"
    sha256 cellar: :any,                 arm64_monterey: "67d0d28536684298cd3039c211422983f1a8b9ac5050660fa3c828f7d6cfc51e"
    sha256 cellar: :any,                 arm64_big_sur:  "9498d150ffac273597ad7efdd01220bc31a90c8a8b62031a5623507b7d82cece"
    sha256 cellar: :any,                 sonoma:         "7cc8174a4f957e462995c64aafef1b468f544b01ecac6b2234baacdd2aafc080"
    sha256 cellar: :any,                 ventura:        "434cf93c1ee8698062a7123acc56a422d3d5899638808c9bfeb00872d253c32f"
    sha256 cellar: :any,                 monterey:       "f27093a85a256425a2acac1fa4293da1101cef25f7a74edc693c75cd6bec39c8"
    sha256 cellar: :any,                 big_sur:        "b8e5990242a9331cda7e78c1b1d3d4117909284f33bb973ab5f1460b7ddbe108"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
    end
  end

  test do
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 20
    assert_predicate user_config_dir/"rom",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
