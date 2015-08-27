#! /usr/bin/ruby1.8

#  mendeleyで生成された *.bib ファイルから
#  不必要な行を削除するプログラム

require 'getoptlong.rb'

parser = GetoptLong.new
parser.set_options(
  ['--input','--i', GetoptLong::REQUIRED_ARGUMENT],
  ['--output','--o', GetoptLong::REQUIRED_ARGUMENT],
  ['--nodoi', GetoptLong::NO_ARGUMENT],
  ['--nonkf', GetoptLong::NO_ARGUMENT],
  ['--chabb', GetoptLong::NO_ARGUMENT],
  ['--help', '-h', GetoptLong::NO_ARGUMENT]
)


#-- initial values
input = './library.bib'
output = './reference.bib'
#output = './test.bib'
doi = true
euc = true
chabb = false
help = false

#-- get input values
parser.each_option do |name,arg|
  name.sub!(/^--/,'')
  case name
  when 'input' , 'i'
    input = arg.to_s
  when 'output' , 'o'
    output = arg.to_s
  when 'nodoi'
    doi = false
  when 'nonkf'
    euc = false
  when 'chabb'
    chabb = true
  when 'help' , 'h'
    help = true
  end
end

#-- help message
if (help)
  usage = "Usage: #{$0.split('/')[-1]}
    --i, --input [string]     specify a output png file (default './library.bib')
    --o, --output [string]    specify a output png file (default './reference.bib')
    --nodoi                   exclude doi (default false)
    --nonkf                   not trun into euc_jp (default false)
    --chabb                   change journal names to their abbreviation (default false)
    -h, --help                show this message"
  puts usage
  exit
end

#-- including_list

including_list =
["@",\
"author = {",\
"editor = {",\
"issn = {",\
"journal = {",\
"month = {",\
"number = {",\
"pages = {",\
"title = {",\
"volume = {",\
"year = {",\
"booktitle = {",\
"publisher = {",\
]
including_list << "doi = {" if doi
including_list << "}"

=begin
including_list =
["@",\
"author = {",\
"editor = {",\
"issn = {",\
"journal = {",\
"month = {",\
"number = {",\
"pages = {",\
"title = {",\
"volume = {",\
"year = {",\
"booktitle = {",\
"doi = {",\
"}"]
=end

###-- $ grep "^@\|^author" library.bib

command = "grep '^#{including_list[0]}"
including_list[1..-1].each_with_index{|include,i|
  command << "\\|^#{include}"
}
command << "'"

add_comma = "| sed -e 's/^}/,}/'"
command << " #{input} #{add_comma}"

###-- change journal abbrevations
abbhash={
  "Journal of the Atmospheric Sciences"=>"JAS",
  "Journal of Climate"=>"JCLI",
  "Reviews of Geophysics"=>"RGEO",
  "Geophysical Research Letters"=>"GRL",
  "Quarterly Journal of the Royal Meteorological Society"=>"QJRMS",
  "Geofysiske Publikasjoner"=>"Geofys. Publ.",
  "Eos"=>"TAGU",
  "Journal of Geophysical Research"=>"JGR",
  "Journal of the Meteorological Society of Japan. Ser. II"=>"JMSJ"
}
if chabb
  add_line=""
  abbhash.each{|jnl,jnlabb|
    add_line << " | sed -e 's/#{jnl}/#{jnlabb}/'"
  }
  command << " #{add_line}"
end

###-----exe command
command << "> #{output}"
puts command
system( command )

###-- $ nkf
if euc
  nkf = (`nkf --guess #{output}`).split[0]
  system("nkf -euc --overwrite #{output}") if nkf!="EUC-JP"
end

