class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.16.3"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.3/apogee_0.16.3_darwin_arm64.tar.gz"
      sha256 "51879f04c8e11f706c7788277648bb79b0028cb2cdddcfb44fe09820a973e617"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.3/apogee_0.16.3_darwin_amd64.tar.gz"
      sha256 "dc742a6f2a3e432e690aea0189bbf37109c65e3290aad6cc2313cd6316ff45d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.3/apogee_0.16.3_linux_arm64.tar.gz"
      sha256 "9e69d938a3e1ce7e9787efbe7febc491f07f388c4e02656d3161ade2296b10e7"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.3/apogee_0.16.3_linux_amd64.tar.gz"
      sha256 "6de6661189b2176d89416b2bd4608e21c0e19eed1153efaa63f07e5643dad666"
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
