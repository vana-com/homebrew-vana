class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.59211c8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-arm64.tar.gz"
      sha256 "1d22d792ae5220a57a776ff547bbd6d21db7a300ab1cff4a16959e38c1432abf"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-x64.tar.gz"
      sha256 "b767cef334bb99c7285e8a658a7d1ee14f5267113e38417b7742ca48d113dec0"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-linux-x64.tar.gz"
    sha256 "818fbf1008b7fca850cb0ad77f865293846244b4e832c4a684925bec6858bd7f"
  end

  def install
    payload_root = Dir.children(buildpath)
      .reject { |entry| entry.start_with?(".") }
      .find { |entry| File.directory?(buildpath/entry) } || "."

    libexec.install (buildpath/payload_root/"app")
    libexec.install (buildpath/payload_root/"vana")
    (bin/"vana").write_env_script libexec/"vana", VANA_APP_ROOT: libexec/"app"
  end

  test do
    assert_match "runtime", shell_output("#{bin}/vana status --json")
  end
end
