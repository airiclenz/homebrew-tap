class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.2"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_darwin_arm64.tar.gz"
      sha256 "ad00ce3c966dc1d6963598be0ae19f32c2e5312e648b4afab392c8d3db46db54"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_darwin_amd64.tar.gz"
      sha256 "b0e5a3395238644e80ddf13bdf2a9950934b02660d7a6da0bd3db578d056cb38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_linux_arm64.tar.gz"
      sha256 "f172e404474a465fb125ca0087dee4df1a76e1989a5c3ff1da3cffa85fba9718"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_linux_amd64.tar.gz"
      sha256 "e0f15ad7e6352eec5171ae988d9683d5715d56ee8ca440518ebaf168ff0bcfb2"
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
