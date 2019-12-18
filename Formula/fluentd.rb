class Fluentd < Formula
  desc "An open source data collector for unified logging layer."
  homepage "https://www.fluentd.org/"
  url "https://github.com/fluent/fluentd.git",
      :tag      => "v1.8.0",
      :revision => "db3d0039ac7dac86955a02f0eda4f3991a9ef617"

  head "https://github.com/fluent/fluentd.git"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["FLUENT_CONF"] = etc/"fluentd"/"fluentd.conf"
    system "gem", "build", "fluentd.gemspec"
    system "gem", "install", "fluentd-#{version}.gem"
    bin.install Dir[libexec/"bin/fluent*"]
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"], :FLUENT_CONF => ENV["FLUENT_CONF"])

    (etc/"fluentd").mkpath
  end

  plist_options :manual => "fluentd"

  def plist; <<~EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <true/>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{opt_bin}/fluentd</string>
    <string>--log</string>
    <string>#{var}/log/fluentd.log</string>
    <string>--use-v1-config</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>WorkingDirectory</key>
  <string>#{var}</string>
</dict>
</plist>
  EOS
  end

  test do
    system "#{bin}/fluentd", "--version"
  end
end
