# The Homebrew formula for blackglass, filled in by scripts/homebrew-formula.sh
# for a release and pushed to github.com/serkanberksoy/homebrew-tap:
#
#   brew install serkanberksoy/tap/blackglass
class Blackglass < Formula
  desc "Note-taking workspace for the terminal: linked Markdown notes, queries, tasks"
  homepage "https://github.com/serkanberksoy/blackglass"
  url "https://github.com/serkanberksoy/blackglass/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "fb013221daf1fc05d65d77ad9c726b4921b7a1d325f63247209801dca2d508a9"
  license "MIT"
  head "https://github.com/serkanberksoy/blackglass.git", branch: "main"

  depends_on "rust" => :build

  # The editor, a library blackglass builds against from beside it
  # (a path dependency, ../mdedit).
  resource "mdedit" do
    url "https://github.com/serkanberksoy/mdedit/archive/refs/tags/v3.23.0.tar.gz"
    sha256 "d03ba884a9eeb6eb5b804efe5b3a538b1ae3384946b6d9b691f2eb5e2050ca9b"
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
