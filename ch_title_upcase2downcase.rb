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

case ttl
when "{Middle Atmosphere Dynamics}"
    ttl_new=ttl
else 
    ttl_new=""
    ttlword = ttl.split(" ")
    ttlword.each_with_index{|tw,i|
      case tw
      when /NCEP/,/NCAR/,/ECMWF/,/ERA/,/JRA/\
        ,/NASA/,/WACCM/,/MRI/,/IPCC/,/Max-Planck/\
        ,/TOGA/,/COARE/,/IOP/,/SHADOZ/\
        ,/SPARC/,/CLIVAR/\
        ,/A-Train/,/SMILES/,/ICESat/,/TRMM/,/TMPA/\
        ,/GPCP/\
        ,/ENSO/,/El/,/Nino/,/^Ni/,/La/,/Nina/\
        ,/Quasi-Biennial/,/Oscillation/\
        ,/QBO/,/ITCZ/,/Kelvin/,/Rossby/,/OLR/,/HRC/\
        ,/MJO/,/Madden/,/Julian/,/Brewer/,/Dobson/\
        ,/TTL/\
        ,/^Eliassen-Palm$/,/Plumb/,/McEwan/\
        ,/WISHE/\
        ,/^Part/,/^I:$/,/^II:$/,/^III:$/\
        ,/GCM/,/CCM/,/CMIP/,/WRF/\
        ,/hPa/,/EOF/\
        ,/Pacific/,/Atlantic/\
        ,/Asia/,/Europ/,/Africa/\
        ,/Tahiti/,/Japan/,/China/,/Russia/,/Austral/\
        ,/Delhi/,/Colcata/,/Cochin/\
        ,/O\\_3/,/^CO/,/^NO/\
        ,/SST/\
        ,/^"/

        ttl_new<<" #{tw}"
      else
        if i==0
          if (tw.length) >= 3
            ttl_new<<" #{tw[0..1].upcase}#{tw[2..-1].downcase}"
          else
            ttl_new<<" #{tw[0..1].upcase}"
          end
        else
          ttl_new<<" #{tw.downcase}"
        end
      end
    }
end
    
    newline="title = {#{ttl_new}},\r\n"

    outfile.puts newline
  else
    outfile.puts line
  end

end
file.close
outfile.close

