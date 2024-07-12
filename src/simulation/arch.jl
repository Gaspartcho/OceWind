

module Arch


# === Importing libraries ===


using MPI
using Oceananigans
using Oceananigans.DistributedComputations



# === Main Function ===

function main()

	@info "Initializing MPI"

	MPI.Init()
	
	comm   = MPI.COMM_WORLD
	rank   = MPI.Comm_rank(comm)
	Nranks = MPI.Comm_size(comm)
	
	ranks = (Nranks, 1, 1)   # Linear distribution
	
	arch = Distributed(
		CPU();
		partition = Partition(ranks...),
		communicator = comm
	)
	
	@info "Running on rank $rank of $Nranks..."
	
	return (arch=arch, rank=rank, comm=comm, Nranks=Nranks)


end


end # module
