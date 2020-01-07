class Cassylab2 < Formula
  desc "LD Didactic CASSY Lab 2"
  homepage "https://www.ld-didactic.de/service/softwaredownload/cassy-s.html"
  url "http://www.ld-didactic.com/software/cassylab2.tar.gz"
  version "2.23"
  sha256 "d13db20d1bd0e3105ffddfe61e4fc3d08cf0375e509e1e9b8390f9662071d9e1"
  
  depends_on "wine"
  depends_on "winetricks"
  depends_on "cabextract"
  depends_on "wget"
  #depends_on :x11
  depends_on "hidapi"
  
  def install
    system "cd hidapi-lan-bridge && make && make PREFIX=#{prefix} install"
    system "wget --quiet -O cassylab2.msi http://www.ld-didactic.de/software/cassylab2_de.msi"
    full_install = true
    copy_from_old = false
    if Dir.exist?("#{opt_prefix}/wine_cassylab2")
      # Update nur möglich, wenn .NET-Version gleich ist
      if `WINEPREFIX=#{opt_prefix}/wine_cassylab2 winetricks list-installed`["dotnet20"]
        # Neuinstallation mit anschließender Kopie der Lizenzdatei
        full_install = true
        copy_from_old = true
      else
        # Update
        system "mv #{opt_prefix}/wine_cassylab2 #{prefix}/"
        full_install = false
      end
    end
    if full_install
      system "mkdir -p #{prefix}/wine_cassylab2"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wineboot -i"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks dotnet35sp1"
      system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 winetricks corefonts tahoma"
    end
    system "WINEPREFIX=#{prefix}/wine_cassylab2 WINEARCH=win32 wine msiexec /i cassylab2.msi /quiet"
    if copy_from_old
      if Dir.exist?("#{opt_prefix}/wine_cassylab2/drive_c/users/Public/Application Data/LD")
        system "mkdir -p \"#{prefix}/wine_cassylab2/drive_c/users/Public/Application Data/\""
        system "cp -r \"#{opt_prefix}/wine_cassylab2/drive_c/users/Public/Application Data/LD\" \"#{prefix}/wine_cassylab2/drive_c/users/Public/Application Data/\""
      elsif Dir.exist?("#{opt_prefix}/wine_cassylab2/drive_c/ProgramData/LD")
        system "mkdir -p \"#{prefix}/wine_cassylab2/drive_c/ProgramData/\""
        system "cp -r \"#{opt_prefix}/wine_cassylab2/drive_c/ProgramData/LD\" \"#{prefix}/wine_cassylab2/drive_c/ProgramData/\""
      end
    end
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
