# -*- coding: EUC-JP -*-
#! /usr/bin/ruby1.9
#
#   論文のタイトルの1文字目以外を小文字にする
#     作成: 2015-8-28(Fri)  Eriko Nishimoto
#

input = (ARGV[0]||'./reference.bib').to_s
output = (ARGV[1]||'./reference2.bib').to_s

puts "Read from #{input} ..\n"
file=File::open(input,"r")

puts "Create output file: #{output} ..\n"
outfile=File::open(output,"w")

while line=file.gets
  line.force_encoding("EUC-JP")

  #-----------------------ch title
  if /^title =/ =~ line
    ttl = line.split("title = {")[-1].split("},\r\n")[0]
    ttlword = ttl.split(" ")

    newline="title = {"
    ttlword.each_with_index{|tw,i|
      case tw
      when /NCEP/,/NCAR/,/ECMWF/,/ERA/,/JRA/\
        ,/NASA/,/WACCM/,/MRI/,/IPCC/,/Max-Planck/\
        ,/TOGA/,/COARE/,/IOP/,/SHADOZ/\
        ,/A-Train/,/SMILES/,/ICESat/,/TRMM/\
        ,/ENSO/,/El /,/Nino/,/Ni\\/,/La /,/Nina/\
        ,/QBO/,/ITCZ/,/Kelvin/,/Rossby/,/OLR/,/HRC/\
        ,/MJO/,/Madden/,/Julian/,/Brewer/,/Dobson/\
        ,/^Eliassen-Palm$/,/Plumb/,/McEwan/\
        ,/WISHE/\
        ,/^Part/,/^I:$/,/^II:$/\
        ,/GCM/,/CCM/,/CMIP/,/WRF/\
        ,/hPa/\
        ,/Pacific/,/Atlantic/\
        ,/Asia/,/Europ/,/Africa/\
        ,/Tahiti/,/Japan/,/China/,/Russia/,/Austral/\
        ,/Delhi/,/Colcata/,/Cochin/\
        ,/O\\_3/,/^CO/,/^NO/\
        ,/^"/

        newline<<" #{tw}"
      else
        if i==0
          if (tw.length) >= 3
            newline<<" #{tw[0..1].upcase}#{tw[2..-1].downcase}"
          else
            newline<<" #{tw[0..1].upcase}"
          end
        else
          newline<<" #{tw.downcase}"
        end
      end
    }
    newline << "},\r\n"

    outfile.puts newline
  else
    outfile.puts line
  end

end
file.close
outfile.close

