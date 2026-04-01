class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.12.0-canary.7843ac9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-telemetry-v3-taxonomy/vana-darwin-arm64.tar.gz"
      sha256 "3c57749e18946335fa5a47c7da16f0f5c6e1bc6b383c3bd6799e4753f1e93eb6"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-telemetry-v3-taxonomy/vana-darwin-x64.tar.gz"
      sha256 "2fa937bfba5822b04c699a0d1719b583138cee58d50ace4e2bc76d71f84b7f84"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-telemetry-v3-taxonomy/vana-linux-x64.tar.gz"
    sha256 "46ac8732df55f471d6b2b35da7e074bf40586091c7459e67c5f10356dfed256f"
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
