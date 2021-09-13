
var w = 1280,
h = 800,
r = 720,
x = d3.scale.linear().range([0, r]),
y = d3.scale.linear().range([0, r]),
node,
root;

var pack = d3.layout.pack().size([r, r]).padding(1).value(function (d) {
    return d.size;
})

var vis = d3.select("body").insert("svg:svg", "h2").attr("width", w).attr("height", h).append("svg:g").attr("transform", "translate(" + (w - r) / 2 + "," + (h - r) / 2 + ")");

var catalogHierarchy = "sp800-53-rev5-map.json";

d3.json(catalogHierarchy, function (data) {
    node = root = data;
    
    var nodes = pack.nodes(root);
    
    vis.selectAll("circle").data(nodes).enter().append("svg:circle").attr("class", function (d) {
        return d.classer;
    }).attr("cx", function (d) {
        return d.x;
    }).attr("cy", function (d) {
        return d.y;
    }).attr("r", function (d) {
        return d.r;
    }).on("click", function (d) {
        return zoom(node == d ? root: d);
    });
    
    vis.selectAll("text").data(nodes).enter().append("svg:text").attr("class", function (d) {
        return d.classer + " title";
    }).attr("x", function (d) {
        return d.x;
    }).attr("y", function (d) {
        return d.y;
    }).attr("dy", ".35em").attr("text-anchor", "middle").style("opacity", function (d) {
        return d.r > 20 ? 1: 0;
    }).text(function (d) {
        return d.name;
    });
    
    vis.selectAll("subtext").data(nodes).enter().append("svg:text").attr("class", function (d) {
        return d.classer + " subtitle";
    }).attr("x", function (d) {
        return d.x;
    }).attr("y", function (d) {
        return d.y;
    }).attr("dy", "1.35em").attr("text-anchor", "middle").style("opacity", function (d) {
        return d.r > 10 ? 1: 0;
    }).text(function (d) {
        return d.desc;
    });
    
    d3.select(window).on("click", function () {
        zoom(root);
    });
});

function zoom(d, i) {
    var k = r / d.r / 2;
    x.domain([d.x - d.r, d.x + d.r]);
    y.domain([d.y - d.r, d.y + d.r]);
    
    var t = vis.transition().duration(d3.event.altKey ? 7500: 750);
    
    t.selectAll("circle").attr("cx", function (d) {
        return x(d.x);
    }).attr("cy", function (d) {
        return y(d.y);
    }).attr("r", function (d) {
        return k * d.r;
    });
    
    t.selectAll("text").attr("x", function (d) {
        return x(d.x);
    }).attr("y", function (d) {
        return y(d.y);
    }).style("opacity", function (d) {
        return k * d.r > 20 ? 1: 0;
    });
    t.selectAll("subtext").attr("x", function (d) {
        return x(d.x);
    }).attr("y", function (d) {
        return y(d.y);
    }).style("opacity", function (d) {
        return k * d.r > 10 ? 1: 0;
    });
    
    node = d;
    d3.event.stopPropagation();
};

function switchflag(flag, whoseq) {
    var who_array = whoseq.split(' ');
    for (var i = 0; i < who_array.length; i++) {
        var who = who_array[i];
        document.getElementById(who).classList.toggle(flag);
    }
}
