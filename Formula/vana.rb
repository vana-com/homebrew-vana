class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.13.1-canary.5f3c748"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-arm64.tar.gz"
      sha256 "7d3bd296d82981c560382991b7f5590f610a37bdc91c2b1700966b9043aa2681"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-x64.tar.gz"
      sha256 "e294d09b9363ac9d14aafee92968df0e5a956e80534219f2307e28d503cce435"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-linux-x64.tar.gz"
    sha256 "184ea04dddf5a1bd13050cb6fc8d8fc148bf01ef1d393f2404641f78cab6b2de"
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
