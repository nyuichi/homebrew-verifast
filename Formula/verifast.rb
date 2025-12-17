class Verifast < Formula
  desc "Modular program verifier for C, Rust and Java using separation logic"
  homepage "https://github.com/verifast/verifast"
  version "25.11"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/verifast/verifast/releases/download/25.11/verifast-25.11-macos-aarch.tar.gz"
      sha256 "f047f44a5884f57a4ad5177ed7eb6d8681fd9631e59681ae32ed8a3d75378bd5"
    else
      url "https://github.com/verifast/verifast/releases/download/25.11/verifast-25.11-macos.tar.gz"
      sha256 "cd98518b499825dc51132e45e0a160856d8b61875bd289c3a76cbb51f8dd5e3d"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    url "https://github.com/verifast/verifast/releases/download/25.11/verifast-25.11-linux.tar.gz"
    sha256 "990c3cadba7cfc9ef9c19d5f1ff039fd746155164fe4a5ec365c625182400f3e"
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
end
