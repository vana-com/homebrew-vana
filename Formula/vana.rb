class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.10.1-canary.5944de8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-arm64.tar.gz"
      sha256 "9f8491d5076b0929634b841d89e4c5fa891d8018e913d2e108aa353190af49e8"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-x64.tar.gz"
      sha256 "16bb3de9efcf45da94193cb30b782763ece493a95a97147e45ae8a5f88e0b52a"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-linux-x64.tar.gz"
    sha256 "641f934925b462f4bd19eaebfb501aad5ea48cc393556aff4c91b2fdee4f2ec3"
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
