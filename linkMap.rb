#!/usr/bin/env ruby
# encoding: utf-8
$:.push File.expand_path("../", __FILE__)
require 'hashToTreeView.rb'

$data = {}
$map_data = {}
$files = {}
link_path = ARGV[0]
map_files = (ARGV[1] == 'files')


File.open(link_path, "r", :encoding => "UTF-8") do |infile|
    while (line = infile.gets)
        begin
            fileData = /^(\[[ 0-9]+\])\s(.*)/.match(line)
            if(fileData)
                $files[fileData[1]] = fileData[2]
            end
            symbolData = /^0x\h+\s0x(\h+)\s(\[[ 0-9]+\])\s(.*)/.match(line)
            if(symbolData)
                key = map_files ? symbolData[2] : symbolData[3]                
                $data[key] = 0 unless ($data.key?(key))
                value = symbolData[1].to_i(16);
                $data[key] += value
            end
        rescue
            line
        end
            
    end
end

$data = $data.sort_by { |a,b| -b }
$index = 0
$other_size = 0
$data.each { |pair| 
    if $index < 1000
        $map_data[pair[0]] = {value:pair[1], info:$files[pair[0]] + ' ' + pair[1].to_s } 
        $index +=1
    else
        $other_size += pair[1]
    end
}
$map_data['OTHER'] = {value:$other_size, info:'OTHER' }

hashToTreeView($map_data)