class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.10.1-canary.e057000"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-arm64.tar.gz"
      sha256 "b290102e9f83909a57e218cf277b59ec0d85613ad77e4bf652c8d3b91f5568bb"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-x64.tar.gz"
      sha256 "8bd40c20002682396670b6cd0f353264f6aea5eedc91707aa88b33f1f1c457d6"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-linux-x64.tar.gz"
    sha256 "f2e51597e4fdbdd2fa42e021ea202d9a7f91b3512d597491757ea332bf0efaa9"
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
