# The Homebrew formula for blackglass, filled in by scripts/homebrew-formula.sh
# for a release and pushed to github.com/serkanberksoy/homebrew-tap:
#
#   brew install serkanberksoy/tap/blackglass
class Blackglass < Formula
  desc "Note-taking workspace for the terminal: linked Markdown notes, queries, tasks"
  homepage "https://github.com/serkanberksoy/blackglass"
  url "https://github.com/serkanberksoy/blackglass/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "65ae6fb4bd04f40dd8293215a75bf7638660e09ca750386298a6c88b518cccb7"
  license "MIT"
  head "https://github.com/serkanberksoy/blackglass.git", branch: "main"

  depends_on "rust" => :build

  # The editor, a library blackglass builds against from beside it
  # (a path dependency, ../mdedit).
  resource "mdedit" do
    url "https://github.com/serkanberksoy/mdedit/archive/refs/tags/v3.21.0.tar.gz"
    sha256 "2370d962986357a0b5b0f8e4fffa25260f5c52de731ec0020b2b469911a57bb2"
  end

  def install
    mdedit = buildpath.parent/"mdedit"
    mdedit.mkpath
    resource("mdedit").stage(mdedit)
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Try the example vault, a tour of every feature:
        blackglass --example
    EOS
  end

  test do
    assert_match "blackglass #{version}", shell_output("#{bin}/blackglass --version")
    system bin/"blackglass", "--help"
  end
end
