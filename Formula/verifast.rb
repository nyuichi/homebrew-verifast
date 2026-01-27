class Verifast < Formula
  desc "Modular program verifier for C, Rust and Java using separation logic"
  homepage "https://github.com/verifast/verifast"

  url "https://github.com/verifast/verifast/releases/download/26.01/verifast-26.01-linux.tar.gz"
  sha256 "13fb7312e7d79076fa6e674d8d3335fb77d9f94749bd65f2d01868ad94dd03eb"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/verifast/verifast/releases/download/26.01/verifast-26.01-macos-aarch.tar.gz"
      sha256 "f316062f224b51f0956bf7375f34089558f4847671ef60e13899da6e079caf00"
    else
      url "https://github.com/verifast/verifast/releases/download/26.01/verifast-26.01-macos.tar.gz"
      sha256 "5535ed6cb130533bf012ab74b4e4284769d8119ec72650317928e1003fedb544"
    end
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    # Some releases are "flat" (bin/, lib/, help/ ... at archive root),
    # others may have a single top-level directory.
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

    # Install everything (including dotfiles like .brew_home if present)
    root.children.each do |child|
      libexec.install child
    end

    # Expose executables via wrappers
    Dir[libexec/"bin/*"].each do |p|
      next if File.directory?(p)

      bin.write_exec_script p
    end
  end

  test do
    output = shell_output("#{bin}/verifast --help 2>&1")
    assert_match "Usage", output
  end
end
