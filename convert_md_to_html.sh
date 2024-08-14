#!/bin/bash

# 函数用于将一个Markdown文件转换为HTML
# sudo apt install pandoc
convert_to_html() {
  local input_file="$1"
  local output_file="${input_file%.md}.html"
  pandoc "$input_file" --toc -s -o "$output_file" --css style.css
  echo "Converted $input_file to $output_file"
}

# 遍历当前文件夹下的所有.md文件并转换为HTML
for md_file in $(find . -type f -name "*.md"); do
  convert_to_html "$md_file"
done

sed 's/.md/.html/g' SUMMARY.html > SUMMARY_RESULT.html
rm SUMMARY.html
mv SUMMARY_RESULT.html SUMMARY.html
