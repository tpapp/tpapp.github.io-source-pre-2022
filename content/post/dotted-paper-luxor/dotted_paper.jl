using Luxor

#######################
# customize script here
#######################
paper = "A4"                       # paper size
major_unit = 1cm                   # gridlines at each
subdivisions = 10                  # dots on gridlines in between
radius = 0.1mm                     # radius for the tiny dots
margins = (5mm, 5mm)               # minimum margins (may be more, centered)
color = "black"                    # color for the tiny dots
filename = "dotted_paper.pdf"      # output goes here, OVERWRITTEN

#######################################################
# runtime code - you probably don't need to change this
#######################################################
pagesize = paper_sizes[paper]
nx, ny = @. floor(Int, (pagesize - (2 * margins)) / major_unit)
offsetx, offsety = @. margins + (pagesize % major_unit) / 2

major_grid_x = offsetx .+ major_unit * (0:nx)
major_grid_y = offsety .+ major_unit * (0:ny)
minor_grid_x = offsetx .+ (major_unit / subdivisions) * (0:(nx*subdivisions))
minor_grid_y = offsety .+ (major_unit / subdivisions) * (0:(ny*subdivisions))

Drawing(paper, filename)
background("white")
sethue(color)
@. circle(Point(major_grid_x, minor_grid_y'), radius, :fill);
@. circle(Point(minor_grid_x, major_grid_y'), radius, :fill);
finish()
preview()
