

# !!! Not this one! See the jupyter notebooks!!!

module PlotData


# === Importing libraries ===

using CairoMakie
using NetCDF



# === Main Function ===

function main(filename, save_file_path)

	u_bar = ncread(filename, "u_bar")
	v_bar = ncread(filename, "v_bar")
	w_bar = ncread(filename, "w_bar")
	T_bar = ncread(filename, "T_bar")
	P_bar = ncread(filename, "P_bar")

	T_w_bar = ncread(filename, "T_w_bar")
	u_w_bar = ncread(filename, "u_w_bar")
	v_w_bar = ncread(filename, "v_w_bar")
	u_P_bar = ncread(filename, "u_P_bar")
	v_P_bar = ncread(filename, "v_P_bar")
	w_P_bar = ncread(filename, "w_P_bar")

	energy = ncread(filename, "energy")
	
	
	
	function log_abs(data)

		if data == 0
			return 0
		end

		return log(abs(data))

	end
	
	
	function plot_data(data, title)

		fig = Figure(size = (800, 700))
		
		ax_h = Axis(fig[1, 1:2]; title=title, xlabel = "t (minutes)", ylabel = "z (meters)")

		dims = size(data)
		
		hm_w = heatmap!(ax_h, 1:dims[1], -dims[2]:0, data)
		Colorbar(fig[1, 3], hm_w)

		ax_l = Axis(fig[2, 1]; title = L"%$title at t = %$(dims[1]) mins", xlabel = "z (meters)", ylabel = title)
		lines!(ax_l, -dims[2]:-1, data[dims[1], :])


		ax_ol = Axis(fig[2, 2]; title = L"log(|%$title|) at t = %$(dims[1]) mins", xlabel = "z (meters)", ylabel = title)
		lines!(ax_ol, -dims[2]:-1, log_abs.(data[dims[1], :]))

		return fig

	end
	
	
	save(save_file_path * "u_bar" * ".png", plot_data(u_bar, L"\bar{u}"))
	save(save_file_path * "v_bar" * ".png", plot_data(v_bar, L"\bar{v}"))
	save(save_file_path * "w_bar" * ".png", plot_data(w_bar, L"\bar{w}"))
	save(save_file_path * "T_bar" * ".png", plot_data(T_bar, L"\bar{T}"))
	save(save_file_path * "P_bar" * ".png", plot_data(P_bar, L"\bar{P}"))

	save(save_file_path * "T_w_bar" * ".png", plot_data(T_w_bar, L"T'w'"))
	save(save_file_path * "u_w_bar" * ".png", plot_data(u_w_bar, L"u'w'"))
	save(save_file_path * "v_w_bar" * ".png", plot_data(v_w_bar, L"v'w'"))
	save(save_file_path * "u_P_bar" * ".png", plot_data(u_P_bar, L"u'P'"))
	save(save_file_path * "v_P_bar" * ".png", plot_data(v_P_bar, L"v'P'"))
	save(save_file_path * "w_P_bar" * ".png", plot_data(w_P_bar, L"w'P'"))

	save(save_file_path * "energy" * ".png", plot_data(energy, L"energy"))


end




end # module
