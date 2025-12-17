class VerifastAT2507 < Formula
  desc "Modular program verifier for C, Rust and Java using separation logic"
  homepage "https://github.com/verifast/verifast"
  license "MIT"

  keg_only :versioned_formula

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/verifast/verifast/releases/download/25.07/verifast-25.07-macos-aarch.tar.gz"
      sha256 "6129fe538fb0b47ddf57e223dd628d991c74d9c835c991dd65871d5dc56c6d3f"
    else
      url "https://github.com/verifast/verifast/releases/download/25.07/verifast-25.07-macos.tar.gz"
      sha256 "7cc1c134f1f794ba1128d83e8c57f72b85bc6dfd2627ec3b13e719c12e210448"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    url "https://github.com/verifast/verifast/releases/download/25.07/verifast-25.07-linux.tar.gz"
    sha256 "48d2c53b4a6e4ba6bf03bd6303dbd92a02bfb896253c06266b29739c78bad23b"
  end

  def install
    root =
      if File.directory?("bin") && File.exist?(File.join("bin", "verifast"))
        Pathname.pwd
      else
        d = Dir.children(".").find do |x|
          File.directory?(x) && File.directory?(File.join(x, "bin")) &&
            File.exist?(File.join(x, "bin", "verifast"))
        end
        odie "Unexpected archive layout: #{Dir.children(".").join(", ")}" unless d
        Pathname.new(d)
      end

    root.children.each do |child|
      libexec.install child
    end

    Dir[libexec/"bin/*"].each do |p|
      next if File.directory?(p)

      bin.write_exec_script p
    end
  end
end
