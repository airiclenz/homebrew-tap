class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.17.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.0/apogee_0.17.0_darwin_arm64.tar.gz"
      sha256 "d044f8eb93d4f3af907ba1cc599b7531aecb711d5e50f5eb37d4cf67ffeeb7ee"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.0/apogee_0.17.0_darwin_amd64.tar.gz"
      sha256 "dd8790c9dc452f1210b6eaa61bdbaf79e4f0e0eb9cb58fa5775614d6c13e9f65"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.0/apogee_0.17.0_linux_arm64.tar.gz"
      sha256 "5e6ffae1903987681f94b778fe4f3a0358ebded150ec396e2aedd985b0b224e3"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.0/apogee_0.17.0_linux_amd64.tar.gz"
      sha256 "1366aef8e158f2a20f0dbc87b6a531cebb26c2c1cf95beffdf5615e2a6e30e9b"
    end
  end

  def install
    bin.install "apogee"
  end

  def caveats
    <<~EOS
      apogee needs an OpenAI-compatible endpoint — a local server (llama.cpp, Ollama,
      LM Studio, vLLM) needs no API key:

        apogee --endpoint http://localhost:8080 --model <name>

      `apogee probe` reports what this host can enforce for Auto mode, for free and
      without calling a model.
    EOS
  end

  test do
    # --version prints "apogee version vX.Y.Z+<build provenance>".
    assert_match version.to_s, shell_output("#{bin}/apogee --version")
    assert_match "apogee", shell_output("#{bin}/apogee --help")
  end
end
