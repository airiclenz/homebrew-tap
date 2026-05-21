class LlamaLauncher < Formula
  desc "CLI tool for managing local LLM servers (llama.cpp, Ollama, LM Studio)"
  homepage "https://github.com/airiclenz/llama-launcher"
  url "https://github.com/airiclenz/llama-launcher/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "804c39c6d491b9578594ea538bfe16c79a0644d3cb93581a79833c13ace2140a"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/airiclenz/llama-launcher/internal/launcher.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llama-launcher version")
  end
end
