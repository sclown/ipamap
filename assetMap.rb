#!/usr/bin/env ruby
# encoding: utf-8
$:.push File.expand_path("../", __FILE__)
require 'hashToTreeView.rb'
require 'json'

asset_path = ARGV[0]
$images = []
$data = {}

asset = JSON.parse(`xcrun --sdk iphoneos assetutil --info #{asset_path}`);
asset.each { |image|
    $images.push(image) if(image.has_key?('RenditionName'))
}
$images = $images.sort { |a,b| 
    b['SizeOnDisk'].to_i <=> a['SizeOnDisk'].to_i
}

$images.each { |image| 
    $data[image['RenditionName']] = {value:image['SizeOnDisk'].to_i, info:image['RenditionName'] + " " + image['SizeOnDisk'].to_s}
}

hashToTreeView($data)
