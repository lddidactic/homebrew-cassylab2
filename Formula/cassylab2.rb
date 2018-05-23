class Cassylab2 < Formula
  desc "LD Didactic CASSY Lab 2"
  homepage "https://www.ld-didactic.de/service/softwaredownload/cassy-s.html"
  url "http://ld-250.local/~kkoop/CASSYLab2-Wine.tar.gz"
  version "2.11"
  
  depends_on "wine"
  depends_on "winetricks"
  depends_on "cabextract"
  depends_on "wget"
  depends_on :x11
  
  def install
    system "cd hidapi-lan-bridge && make VERBOSE=1 && make VERBOSE=1 PREFIX=#{prefix} install"
    system "wget --quiet -O cassylab2.msi http://www.ld-didactic.de/software/cassylab2_de.msi"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks -q dotnet20sp2 corefonts tahoma || true"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks -q dotnet20sp2 || true"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wine msiexec /i cassylab2.msi /quiet"
    system "cp cassylab2.sh_ cassylab2.sh"
    inreplace "cassylab2.sh","$$$PREFIX$$$","#{prefix}/wine_cassylab2"
    inreplace "cassylab2.sh","$$$LANG$$$","de"
    inreplace "cassylab2.sh","$PREFIX/cassybridge","cassybridge"
    #bin.install "cassylab2.sh"
    system "install -d #{prefix}/bin/"
    system "cp cassylab2.sh #{prefix}/bin/"
    system "cp -r mac/cassylab2.app #{prefix}"
    ohai "------------------------------------------------------------------"
    ohai "CASSY Lab 2 was installed. To create an application link, execute "
    ohai "  sudo ln -s #{prefix}/cassylab2.app /Applications"
    ohai "------------------------------------------------------------------"
  end
  
end