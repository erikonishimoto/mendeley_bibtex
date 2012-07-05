#! /usr/bin/ruby1.8

#  mendeleyで生成された *.bib ファイルから
#  不必要な行を削除するプログラム

input = './library.bib'
output = './reference.bib'
#output = './test.bib'

including_list =
["@",\
"author = {",\
"editor = {",\
"doi = {",\
"issn = {",\
"journal = {",\
"month = {",\
"number = {",\
"pages = {",\
"title = {",\
"volume = {",\
"year = {",\
"booktitle = {",\
"}"]

###-- $ grep "^@\|^author" library.bib

command = "grep '^#{including_list[0]}"
including_list[1..-1].each_with_index{|include,i|
  command << "\\|^#{include}"
}
add_comma = "| sed -e 's/^}/,}/'"

command << "' #{input} #{add_comma} > #{output}"

puts command
system( command )

###-- $ nkf
nkf = (`nkf --guess #{output}`).split[0]
system("nkf -euc --overwrite #{output}") if nkf!="EUC-JP"

