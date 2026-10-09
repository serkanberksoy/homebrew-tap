# The Homebrew formula for blackglass, filled in by scripts/homebrew-formula.sh
# for a release and pushed to github.com/serkanberksoy/homebrew-tap:
#
#   brew install serkanberksoy/tap/blackglass
class Blackglass < Formula
  desc "Note-taking workspace for the terminal or a window: linked Markdown, queries, tasks"
  homepage "https://github.com/serkanberksoy/blackglass"
  url "https://github.com/serkanberksoy/blackglass/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "2e2c94a8b737e99c3b041325d01cc8940e5568973fadbf135936ac03b072d4c4"
  license "MIT"
  head "https://github.com/serkanberksoy/blackglass.git", branch: "main"

  depends_on "rust" => :build

  # The editor, a library blackglass builds against from beside it
  # (a path dependency, ../mdedit).
  resource "mdedit" do
    url "https://github.com/serkanberksoy/mdedit/archive/refs/tags/v3.24.0.tar.gz"
    sha256 "a118462edfe59e4e4762739f7a071fa6820316fce971c68733f8bd5640c4476f"
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
      Open it in a window of its own (your fonts, pictures, color emoji):
        blackglass --gui --example
    EOS
  end

  test do
    assert_match "blackglass #{version}", shell_output("#{bin}/blackglass --version")
    system bin/"blackglass", "--help"
  end
end
