class LlamaLauncher < Formula
  desc "CLI tool for managing local LLM servers (llama.cpp, Ollama, LM Studio)"
  homepage "https://github.com/airiclenz/llama-launcher"
  url "https://github.com/airiclenz/llama-launcher/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "90fe73e41b7a4c8b85f585884f36915e7d947e9a9b9a4aebeeb0f0ca6ff41ce3"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/airiclenz/llama-launcher/internal/launcher.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    # Optional control-plane adapter: exposes the lifecycle commands as MCP
    # tools over HTTP for container-to-host control (ADR-0008).
    mcp_ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"llama-launcher-mcp", ldflags: mcp_ldflags),
           "./cmd/llama-launcher-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llama-launcher version")
    assert_match version.to_s, shell_output("#{bin}/llama-launcher-mcp --version")
  end
end
