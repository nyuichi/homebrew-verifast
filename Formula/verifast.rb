class Verifast < Formula
  desc "Modular program verifier for C, Rust and Java using separation logic"
  homepage "https://github.com/verifast/verifast"
  license "MIT"
  version "25.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/verifast/verifast/releases/download/25.11/verifast-25.11-macos-aarch.tar.gz"
      sha256 "f047f44a5884f57a4ad5177ed7eb6d8681fd9631e59681ae32ed8a3d75378bd5"
    else
      url "https://github.com/verifast/verifast/releases/download/25.11/verifast-25.11-macos.tar.gz"
      sha256 "cd98518b499825dc51132e45e0a160856d8b61875bd289c3a76cbb51f8dd5e3d"
    end
  end

  def install
    # The archive usually contains a top-level directory such as verifast-25.11/ or verifast-<commit>/
    top = Dir["verifast-*"].find { |d| File.directory?(d) }
    odie "Unexpected archive layout: #{Dir.children(".").join(", ")}" unless top

    libexec.install Dir["#{top}/*"]

    # Expose all executables shipped in the distribution.
    Dir[libexec/"bin/*"].each do |p|
      next if File.directory?(p)
      bin.write_exec_script p
    end
  end

  test do
    out = shell_output("#{bin}/verifast --help 2>&1", 0)
    assert_match(/VeriFast|verifast/i, out)
  end
end

