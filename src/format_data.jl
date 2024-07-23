

module FormatData


# === Importing libraries ===

using NetCDF
using YAXArrays
using DimensionalData



# === Main Function ===

function main(filename, save_file_name)

	@info "Importing Data..."

	ds = open_dataset(filename, driver=:netcdf)
	
	@show ds.u
	
	function format_axes(x)
		axlist = (
			Dim{:xC}(val(x.axes[1])),
			Dim{:yC}(val(x.axes[2])),
			Dim{:zC}(val(x.axes[3])),
			Dim{:Ti}(val(x.axes[4]))
		)
		
		return YAXArray(axlist, x, x.properties)
	end
	
	@show u = format_axes(ds.u)
	v = format_axes(ds.v)
	w = format_axes(ds.w[:, :, 2:end, :])
	T = format_axes(ds.T)
	P = format_axes(ds.P)
	
	@show u

	@info "Pre-formating data..."


	function to_bar(x)
		return YAXArrays.mapslices(sum, x, dims=("xC", "yC")) ./ (128*128)
	end
	
	function to_prime(x, x_bar)
		return x .- reshape(x_bar, (1, 1, size(x_bar)...))
	end


	u_bar = to_bar(u)
	v_bar = to_bar(v)
	w_bar = to_bar(w)
	T_bar = to_bar(T)
	P_bar = to_bar(P)


	u_prime = to_prime(u, u_bar)
	v_prime = to_prime(v, v_bar)
	w_prime = to_prime(w, w_bar)
	T_prime = to_prime(T, T_bar)
	P_prime = to_prime(P, P_bar)


	@show T_w_bar = to_bar(T_prime .* w_prime)
	u_w_bar = to_bar(u_prime .* w_prime)
	v_w_bar = to_bar(v_prime .* w_prime)


	energy = (to_bar(u_prime .^ 2) .+ to_bar(v_prime .^ 2) .+ to_bar(w_prime .^ 2)) .* 0.5

	u_P_bar = to_bar(u_prime .* P_prime)
	v_P_bar = to_bar(v_prime .* P_prime)
	w_P_bar = to_bar(w_prime .* P_prime)


	if isfile(save_file_name)
		rm(save_file_name)
		@info "Deleting old save file..."
	end
	
	@info "Generating dataset..."
	
	final_ds = Dataset(
		u_bar = transpose(u_bar),
		v_bar = transpose(v_bar),
		w_bar = transpose(w_bar),
		T_bar = transpose(T_bar),
		P_bar = transpose(P_bar),
		
		T_w_bar = transpose(T_w_bar),
		u_w_bar = transpose(u_w_bar),
		v_w_bar = transpose(v_w_bar),
		
		u_P_bar = transpose(u_P_bar),
		v_P_bar = transpose(v_P_bar),
		w_P_bar = transpose(w_P_bar),
		
		energy = transpose(energy)
	)
	
	@info "Saving the formated data..."
	
	savedataset(final_ds, path=save_file_name, driver=:netcdf)


	return


end

end # module
