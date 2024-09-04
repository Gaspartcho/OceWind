
# This small script just takes the last time slice of the generated
# data so it can fit into the git repo

module FormatData


# === Importing libraries ===

using NetCDF
using YAXArrays
using DimensionalData


function format_axes(x)
	axlist = (
		Dim{:xC}(val(x.axes[1])),
		Dim{:yC}(val(x.axes[2])),
		Dim{:zC}(val(x.axes[3])),
	)

	return YAXArray(axlist, x)
end

function to_bar(x)
	dims = size(x)
	return YAXArrays.mapslices(sum, x, dims=("xC", "yC")) ./ (dims[1] * dims[2])
end

function to_prime(x, x_bar)
	return x .- reshape(x_bar, (1, 1, size(x_bar)...))
end




# === Main Function ===

function main(filename, save_file_name)

	@info "Importing Data..."

	ds = open_dataset(filename, driver=:netcdf)

	dims = size(ds.u)
	
	u = format_axes(ds.u[Ti = dims[4]])
	v = format_axes(ds.v[Ti = dims[4]])
	w = format_axes(ds.w[Ti = dims[4]])
	T = format_axes(ds.T[Ti = dims[4]])
	P = format_axes(ds.P[Ti = dims[4]])

	w = format_axes(w[:, :, 2:end])

	
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


	T_w_bar = to_bar(T_prime .* w_prime)
	u_w_bar = to_bar(u_prime .* w_prime)
	v_w_bar = to_bar(v_prime .* w_prime)

	u_P_bar = to_bar(u_prime .* P_prime)
	v_P_bar = to_bar(v_prime .* P_prime)
	w_P_bar = to_bar(w_prime .* P_prime)

	energy  = (to_bar(u_prime .^ 2) .+ to_bar(v_prime .^ 2) .+ to_bar(w_prime .^ 2)) .* 0.5

	if isfile(save_file_name)
		rm(save_file_name)
		@info "Deleting old save file..."
	end

	@info "Generating dataset..."

	final_ds = Dataset(
		u_bar = u_bar,
		v_bar = v_bar,
		w_bar = w_bar,
		T_bar = T_bar,
		P_bar = P_bar,

		T_w_bar = T_w_bar,
		u_w_bar = u_w_bar,
		v_w_bar = v_w_bar,

		u_P_bar = u_P_bar,
		v_P_bar = v_P_bar,
		w_P_bar = w_P_bar,

		energy = energy,

		T_x = ds.T[Ti = dims[4], xC = dims[1]],
		T_y = ds.T[Ti = dims[4], yC = dims[2]],
		T_z = ds.T[Ti = dims[4], zC = dims[3]]
	)


	@info "Saving the formated data..."

	savedataset(final_ds, path=save_file_name, driver=:netcdf)


	return


end

end # module
