# encoding: utf-8
require 'rubyvis'

def hashToTreeView data
    node_data = {}
    data.each { |key, value|
        node_data[key] = value[:value]
    }
    format=Rubyvis::Format.number
    color = pv.Colors.category20
    vis = pv.Panel.new()
                    .width(720)
                    .height(720)
    nodes = pv.dom(node_data).root("rubyvis").nodes
    treemap = vis.add(Rubyvis::Layout::Treemap).nodes(nodes).mode("squarify").round(true)
    
    treemap.leaf.add(Rubyvis::Panel)
        .fill_style(lambda{|d| color.scale(d.parent_node.node_name)})
        .stroke_style("#fff")
        .line_width(1)
        .title(lambda {|d| 
            data[d.node_name][:info]
        })
    
    treemap.node_label.add(Rubyvis::Label)
        .text(lambda {|d| 
            d.node_name if d.index < 10
        })

    vis.render
    puts vis.to_svg

end
