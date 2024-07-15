

module FormatData


# === Importing libraries ===

using NetCDF



# === Main Function ===

function main(nb_ranks, read_file_path, save_file_name)

	@info "Importing Data..."

	filename = string(read_file_path, 0, ".nc")

	u = ncread(filename, "u")
	v = ncread(filename, "v")
	w = ncread(filename, "w")
	T = ncread(filename, "T")
	P = ncread(filename, "P")


	for i in 1:nb_ranks-1

		filename = string(read_file_path, i, ".nc")

		u = cat(u, ncread(filename, "u"), dims=1)
		v = cat(v, ncread(filename, "v"), dims=1)
		w = cat(w, ncread(filename, "w"), dims=1)
		T = cat(T, ncread(filename, "T"), dims=1)
		P = cat(P, ncread(filename, "P"), dims=1)

	end


	w = w[:, :, 1:size(w)[3]-1, :] # small bug here...


	@info "Pre-formating data..."


	function to_bar(x)
		dims = size(x)
		tmp = sum(x, dims=(1, 2)) / (4 * dims[1] * dims[2])
		return repeat(tmp, outer = (dims[1], dims[2], 1, 1))

	end


	u_bar = to_bar(u)
	v_bar = to_bar(v)
	w_bar = to_bar(w)
	T_bar = to_bar(T)
	P_bar = to_bar(P)


	u_prime = u - u_bar
	v_prime = v - v_bar
	w_prime = w - w_bar
	T_prime = T - T_bar
	P_prime = P - P_bar


	T_w_bar = to_bar(T_prime .* w_prime)
	u_w_bar = to_bar(u_prime .* w_prime)
	v_w_bar = to_bar(v_prime .* w_prime)


	energy  = 0.5 * (to_bar(u_prime .^ 2) + to_bar(v_prime .^ 2) + to_bar(w_prime .^ 2))

	u_P_bar = to_bar(u_prime .* P_prime)
	v_P_bar = to_bar(v_prime .* P_prime)
	w_P_bar = to_bar(w_prime .* P_prime)


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
	create_save_var(size(T_bar), "T_bar")
	create_save_var(size(P_bar), "P_bar")

	create_save_var(size(T_w_bar), "T_w_bar")
	create_save_var(size(u_w_bar), "u_w_bar")
	create_save_var(size(v_w_bar), "v_w_bar")
	create_save_var(size(u_P_bar), "u_P_bar")
	create_save_var(size(v_P_bar), "v_P_bar")
	create_save_var(size(w_P_bar), "w_P_bar")

	create_save_var(size(energy), "energy")


	function save_var(var, varname)
		ncwrite(
			Array(transpose(var[1, 1, :, :])),
			save_file_name,
			varname,
			start=[1, 1],
			count=[-1, -1]
		)
	end

	save_var(u_bar, "u_bar")
	save_var(v_bar, "v_bar")
	save_var(w_bar, "w_bar")
	save_var(T_bar, "T_bar")
	save_var(P_bar, "P_bar")

	save_var(T_w_bar, "T_w_bar")
	save_var(u_w_bar, "u_w_bar")
	save_var(v_w_bar, "v_w_bar")
	save_var(u_P_bar, "u_P_bar")
	save_var(v_P_bar, "v_P_bar")
	save_var(w_P_bar, "w_P_bar")

	save_var(energy, "energy")


	return



end

end # module
