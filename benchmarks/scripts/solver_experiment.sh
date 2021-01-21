base="/home/vagrant/benchmarks/"
result_base="/home/vagrant/experiment/klee-results"
script_base=""
bcfile=""
output_dir=""

set_output_dir() {
	output_dir="${result_base}/$1-$2-$3-$4"
}

set_bcfile() {
	pgm=$1
	bcfile=$(find ${base} -name "${pgm}.bc" 2>/dev/null)
}

set_script_dir() {
	script_base=$(cd "$(dirname $1)"; echo "${PWD}")
}

run_klee() {
	local pgm=$1
	local solver
	local max_time
	local search_strategies
	local search_opt

	if [[ $# -eq 5 ]]; then
		solver=$4
		max_time=$5
		search_strategies="$2-$3"
		search_opt="--search=$2 --search=$3"
	elif [[ $# -eq 4 ]]; then
		solver=$3
		max_time=$4
		search_strategies=$2
		search_opt="--search=$2"
	else
		echo "Invalid arguments"
		exit
	fi

	set_output_dir ${pgm} ${search_strategies} ${solver} ${max_time}
	set_bcfile ${pgm}

	local optimzie="--optimize --simplify-sym-indices --disable-inlining"
	local solver="--solver-backend=${solver} --use-forked-solver --use-cex-cache --use-query-log=solver:kquery,all:kquery"
	local libs="--libc=uclibc --posix-runtime"
	local output="--only-output-states-covering-new --output-module=true --output-source=true --output-stats=true --output-dir=${output_dir}"
	local budgets="--max-sym-array-size=4096 --max-memory-inhibit=false --max-time=${max_time}"
	local env="--env-file=${script_base}/test.env"
	local opt="--switch-type=internal --watchdog"
	local search="${search_opt} --use-batching-search --batch-instructions=10000"
	local args="--sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdin 8 --sym-stdout"
	
	ulimit -s unlimited && ulimit -n 1000000 && ulimit -c unlimited && \
		klee ${optimize} ${solver} ${libs} ${output} ${budgets} ${env} ${opt} ${search} \
		${bcfile} ${args}
}

main() {
	set_script_dir $0
	echo $script_base

	if [[ ! -d ${result_base} ]]; then
		mkdir -p "${result_base}"
	fi
	
	run_klee gcal nurs:md2u random-state stp 7200s
#	run_klee gcal nurs:qc stp 7200s
	run_klee combine nurs:md2u random-state stp 7200s
#	run_klee combine nurs:qc stp 7200s
	run_klee trueprint nurs:md2u random-state stp 7200s
#	run_klee trueprint nurs:qc stp 7200s

#	run_klee gcal nurs:md2u random-state z3 7200s
#	run_klee gcal nurs:qc z3 7200s
#	run_klee combine nurs:md2u random-state z3 7200s
#	run_klee combine nurs:qc z3 7200s
#	run_klee trueprint nurs:md2u random-state z3 7200s
#	run_klee trueprint nurs:qc z3 7200s
}

main
