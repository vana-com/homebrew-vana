class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.74dd599"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-auth-only-mode/vana-darwin-arm64.tar.gz"
      sha256 "d21c10e659292c90dc85a89bed961c6739b0aa27eee477aea6c0e2dd2682e169"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-auth-only-mode/vana-darwin-x64.tar.gz"
      sha256 "7aa8db5b6d619304d952fc450cab793fa81b3082ae268ee986414aad8b393971"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-auth-only-mode/vana-linux-x64.tar.gz"
    sha256 "615a8fc2cd2c13a7de89f58c75a7b997d0ec20b99abb7b6f7e5703029ab70527"
  end

  def install
    payload_root =
      if (buildpath/"vana").exist? && (buildpath/"app").directory?
        buildpath
      else
        child = Dir.children(buildpath)
          .reject { |entry| entry.start_with?(".") }
          .find { |entry| File.directory?(buildpath/entry) }
        raise "Unable to locate Vana payload root" unless child

        buildpath/child
      end

    libexec.install payload_root/"app"
    libexec.install payload_root/"vana"
    (bin/"vana").write_env_script libexec/"vana", VANA_APP_ROOT: libexec/"app"
  end

  test do
    assert_match "runtime", shell_output("#{bin}/vana status --json")
  end
end
