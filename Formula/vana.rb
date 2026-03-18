class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.e717ce9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-arm64.tar.gz"
      sha256 "aae3588c9de97a4bb55f79b7e8890a848d2bb7ad97d8745aaff5d8d2ceaa9a05"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-x64.tar.gz"
      sha256 "98a71dd79a7d9e89a49e1cbb8fd928fecc31fde3213e3263c763a37cef65daf9"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-linux-x64.tar.gz"
    sha256 "26e1e0521c7ed24554806bb1a1bce8e1a83319fabb973203deb96196cc3090bc"
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
