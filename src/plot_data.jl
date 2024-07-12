

# !!! Not this one! See the jupyter notebooks!!!

module PlotData


# === Importing libraries ===

using CairoMakie


# === Main Function ===

function main(filename)

	fig = Figure(size = (1000, 500))
	
	ax = Axis(fig; title="test")
	
	@show data
	hm_w = heatmap!(ax, data.w_bar)
	Colorbar(fig, hm_w)
	
	
	
	fig

end




end # module
