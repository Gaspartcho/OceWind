

module FormatData


# === Importing libraries ===

using NetCDF
using YAXArrays
using DimensionalData



function create_empty_array(x)

	dims = size(x)

	axlist = (
		Dim{:Ti}(val(x.axes[4])),
		Dim{:zC}(val(x.axes[3])),

	)
	
	return YAXArray(axlist, zeros(dims[4], dims[3]))

end



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
	
	
	
	u_bar = create_empty_array(ds.u)
	v_bar = create_empty_array(ds.u)
	w_bar = create_empty_array(ds.u)
	T_bar = create_empty_array(ds.u)
	P_bar = create_empty_array(ds.u)

	T_w_bar = create_empty_array(ds.u)
	u_w_bar = create_empty_array(ds.u)
	v_w_bar = create_empty_array(ds.u)
	
	u_P_bar = create_empty_array(ds.u)
	v_P_bar = create_empty_array(ds.u)
	w_P_bar = create_empty_array(ds.u)

	energy = create_empty_array(ds.u)


	@info "Pre-formating data..."

	
	for time_slice in 1:dims[4]
		@info time_slice
		
		u = format_axes(ds.u[Ti = time_slice])
		v = format_axes(ds.v[Ti = time_slice])
		w = format_axes(ds.w[Ti = time_slice])
		T = format_axes(ds.T[Ti = time_slice])
		P = format_axes(ds.P[Ti = time_slice])
				
		w = format_axes(w[:, :, 2:end])
		
		u_bar[time_slice, :] = u_bar_this = to_bar(u)
		v_bar[time_slice, :] = v_bar_this = to_bar(v)
		w_bar[time_slice, :] = w_bar_this = to_bar(w)
		T_bar[time_slice, :] = T_bar_this = to_bar(T)
		P_bar[time_slice, :] = P_bar_this = to_bar(P)
		
		u_prime = to_prime(u, u_bar_this)
		v_prime = to_prime(v, v_bar_this)
		w_prime = to_prime(w, w_bar_this)
		T_prime = to_prime(T, T_bar_this)
		P_prime = to_prime(P, P_bar_this)
		
		
		T_w_bar[time_slice, :] = to_bar(T_prime .* w_prime)
		u_w_bar[time_slice, :] = to_bar(u_prime .* w_prime)
		v_w_bar[time_slice, :] = to_bar(v_prime .* w_prime)

		u_P_bar[time_slice, :] = to_bar(u_prime .* P_prime)
		v_P_bar[time_slice, :] = to_bar(v_prime .* P_prime)
		w_P_bar[time_slice, :] = to_bar(w_prime .* P_prime)

		energy[time_slice, :]  = (to_bar(u_prime .^ 2) .+ to_bar(v_prime .^ 2) .+ to_bar(w_prime .^ 2)) .* 0.5

	
	end



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
		
		energy = energy
	)
	
	@info "Saving the formated data..."
	
	savedataset(final_ds, path=save_file_name, driver=:netcdf)


	return


end

end # module
