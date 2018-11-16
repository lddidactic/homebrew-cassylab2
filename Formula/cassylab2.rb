class Cassylab2 < Formula
  desc "LD Didactic CASSY Lab 2"
  homepage "https://www.ld-didactic.de/service/softwaredownload/cassy-s.html"
  url "http://www.ld-didactic.com/software/cassylab2.tar.gz"
  version "2.22"
  sha256 "ac0001fb999fe3a74bed6412961a5f724aee1b89eefb911119e98a392d552e5e"
  
  depends_on "wine"
  depends_on "winetricks"
  depends_on "cabextract"
  depends_on "wget"
  #depends_on :x11
  depends_on "hidapi"
  
  def install
    system "cd hidapi-lan-bridge && make && make PREFIX=#{prefix} install"
    system "wget --quiet -O cassylab2.msi http://www.ld-didactic.de/software/cassylab2_de.msi"
    if Dir.exist?("#{opt_prefix}/wine_cassylab2")
      # Update
      system "mv #{opt_prefix}/wine_cassylab2 #{prefix}/"
    else
      # Neuinstallation
      system "mkdir -p #{prefix}/wine_cassylab2"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wineboot -i"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks dotnet20sp2 || true"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks -q dotnet20sp2"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks corefonts tahoma"
    end
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wine msiexec /i cassylab2.msi /quiet"
    system "cp cassylab2.sh_ cassylab2.sh"
    inreplace "cassylab2.sh","$$$PREFIX$$$","#{prefix}/wine_cassylab2"
    inreplace "cassylab2.sh","$$$LANG$$$",""
    inreplace "cassylab2.sh","$PREFIX/cassybridge","cassybridge"
    #bin.install "cassylab2.sh"
    system "install -d #{prefix}/bin/"
    system "cp cassylab2.sh #{prefix}/bin/"
    system "cp mac/update-cassylab2.sh #{prefix}/bin/update-cassylab2"
    system "cp -r mac/cassylab2.app #{prefix}"
  end
end
