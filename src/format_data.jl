

module FormatData


# === Importing libraries ===

using NetCDF



# === Main Function ===

function main(filename, save_file_name)

	@info "Importing Data..."


	u = NetCDF.open(filename, "u")
	v = NetCDF.open(filename, "v")
	w = NetCDF.open(filename, "w")
	#T = NetCDF.open(filename, "T")
	#P = NetCDF.open(filename, "P")


	w = w[:, :, 1:size(w)[3]-1, :] # small bug here...


	@info "Pre-formating data..."


	function to_bar(x)
		return (sum(x, dims=(1, 2)) / (128*128))[1, 1, :, :]
	end
	
	function to_prime(x, x_bar)
		dims = size(x)
		tmp = zeros(dims)
		for i in 1:dims[1]
			for j in 1:dims[2]
				tmp[:, :, i, j] = x[:, :, i, j] - x_bar[i, j]
			end
		end
		
		return tmp

	end


	u_bar = to_bar(u)
	v_bar = to_bar(v)
	w_bar = to_bar(w)
	#T_bar = to_bar(T)
	#P_bar = to_bar(P)


	u_prime = to_prime(u, u_bar)
	v_prime = to_prime(v, v_bar)
	w_prime = to_prime(w, w_bar)
	#T_prime = to_prime(T, T_bar)
	#P_prime = to_prime(P, P_bar)


	#T_w_bar = to_bar(T_prime .* w_prime)
	u_w_bar = to_bar(u_prime .* w_prime)
	v_w_bar = to_bar(v_prime .* w_prime)


	energy  = 0.5 * (to_bar(u_prime .^ 2) + to_bar(v_prime .^ 2) + to_bar(w_prime .^ 2))

	#u_P_bar = to_bar(u_prime .* P_prime)
	#v_P_bar = to_bar(v_prime .* P_prime)
	#w_P_bar = to_bar(w_prime .* P_prime)


	if isfile(save_file_name)
		rm(save_file_name)
		@info "Deleting old save file!"
	end

	dims = size(u_bar)


	function create_save_var(dims, varname)
		nccreate(
			save_file_name,
			varname,
			"t", collect(1:dims[4]), Dict("units" => "s", "longname" => "Time"),
			"z", collect(1:dims[3]), Dict("units" => "m", "longname" => "Depth")
		)
	end


	@info "Saving all the formated data!"


	create_save_var(size(u_bar), "u_bar")
	create_save_var(size(v_bar), "v_bar")
	create_save_var(size(w_bar), "w_bar")
	#create_save_var(size(T_bar), "T_bar")
	#create_save_var(size(P_bar), "P_bar")

	#create_save_var(size(T_w_bar), "T_w_bar")
	create_save_var(size(u_w_bar), "u_w_bar")
	create_save_var(size(v_w_bar), "v_w_bar")
	#create_save_var(size(u_P_bar), "u_P_bar")
	#create_save_var(size(v_P_bar), "v_P_bar")
	#create_save_var(size(w_P_bar), "w_P_bar")

	create_save_var(size(energy), "energy")


	function save_var(var, varname)
		ncwrite(
			Array(transpose(var)),
			save_file_name,
			varname,
			start=[1, 1],
			count=[-1, -1]
		)
	end

	save_var(u_bar, "u_bar")
	save_var(v_bar, "v_bar")
	save_var(w_bar, "w_bar")
	#save_var(T_bar, "T_bar")
	#save_var(P_bar, "P_bar")

	#save_var(T_w_bar, "T_w_bar")
	save_var(u_w_bar, "u_w_bar")
	save_var(v_w_bar, "v_w_bar")
	#save_var(u_P_bar, "u_P_bar")
	#save_var(v_P_bar, "v_P_bar")
	#save_var(w_P_bar, "w_P_bar")

	save_var(energy, "energy")


	return



end

end # module
