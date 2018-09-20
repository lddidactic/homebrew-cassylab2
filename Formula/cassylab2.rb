class Cassylab2 < Formula
  desc "LD Didactic CASSY Lab 2"
  homepage "https://www.ld-didactic.de/service/softwaredownload/cassy-s.html"
  #url http://www.ld-didactic.com/software/cassylab2.tar.gz
  url "https://raw.githubusercontent.com/lddidactic/homebrew-cassylab2/master/Package/cassylab2.tar.gz"
  version "2.11"
  sha256 "a676c3350af182a9bfd6e70b7bcc948b86b004e916533b42b4ea0ce69baf9ce8"
  
  depends_on "wine"
  depends_on "winetricks"
  depends_on "cabextract"
  depends_on "wget"
  depends_on :x11
  depends_on "hidapi"
  
  def install
    system "cd hidapi-lan-bridge && make && make PREFIX=#{prefix} install"
    system "wget --quiet -O cassylab2.msi http://www.ld-didactic.de/software/cassylab2_de.msi"
    system "mkdir -p #{prefix}/wine_cassylab2"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wineboot -i"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks dotnet20sp2 corefonts tahoma || true"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks -q dotnet20sp2"
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wine msiexec /i cassylab2.msi /quiet"
    system "cp cassylab2.sh_ cassylab2.sh"
    inreplace "cassylab2.sh","$$$PREFIX$$$","#{prefix}/wine_cassylab2"
    inreplace "cassylab2.sh","$$$LANG$$$","de"
    inreplace "cassylab2.sh","$PREFIX/cassybridge","cassybridge"
    #bin.install "cassylab2.sh"
    system "install -d #{prefix}/bin/"
    system "cp cassylab2.sh #{prefix}/bin/"
    system "cp -r mac/cassylab2.app #{prefix}"
  end

  def caveats; <<~EOS
    ------------------------------------------------------------------
    CASSY Lab 2 was installed. To create an application link, execute 
    sudo ln -s #{prefix}/cassylab2.app /Applications
    ------------------------------------------------------------------
  EOS
  end
end
