#'@title run GLM on a mac
#'@param sim_folder the directory where simulation files are contained
#'@param verbose should output of GLM be shown
#'@keywords methods
#'@seealso \link{compare_to_field}, \link{resample_to_field}, \link{read_nml}, \link{get_metrics}
#'@author
#'Jordan S. Read
#'@examples 
#'\dontrun{
#'library(glmtools)
#'sim_folder <- system.file('extdata/sim/', package = 'GLMr')
#'run_glm(sim_folder)
#'out_file <- file.path(sim_folder,'output.nc')
#'nml_file <- system.file('extdata/sim', 'glm.nml', package = 'GLMr')
#'field_file <- system.file('extdata', 'field_data.tsv', package = 'GLMr')
#'plot_temp(file = out_file, fig_path = 'test_temp.png')
#'model_diagnostics(out_file, field_file, nml_file = nml_file,
#'    metrics = c('thermo.depth', 'schmidt.stability'),
#'    fig_path = FALSE)
#'
#' }
#'@export
run_glm <- function(sim_folder, verbose=TRUE){
	
	#Just going to brute force this at the moment.
	if(.Platform$pkgType == "win.binary"){
		if(.Platform$r_arch != "x64"){
			warning("You are running a 32-bit version of R.", 
							"Windows GLM only supports 64-bit. This may cause issues.")
		}
		
		run_glmWin(sim_folder, verbose)
		
	}else if(.Platform$pkgType == "mac.binary" || 
					 	.Platform$pkgType == "mac.binary.mavericks"){
		
		run_glmOSx(sim_folder, verbose)
		
	}else if(.Platform$pkgType == "source"){
		## Probably running linux
		stop("Currently UNIX is not supported by GLMr")
	}
	
}


run_glmWin <- function(sim_folder, verbose = TRUE){
	glm_path <- system.file('extbin/winGLM/glm.exe', package=getPackageName())
	origin <- getwd()
	setwd(sim_folder)
	
	tryCatch({
		if (verbose){
			out <- system2(glm_path, wait = TRUE, stdout = stdout, stderr = stderr)
		} else {
			out <- system2(glm_path, wait = TRUE, stdout = NULL, stderr = NULL)
		}
		setwd(origin)
	}, error = function(err) {
		print(paste("GLM_ERROR:  ",err))
		setwd(origin)
	})
}


run_glmOSx <- function(sim_folder, verbose = TRUE){
  glm_path <- system.file('extdata/sim/glm', package=getPackageName())
  origin <- getwd()
  setwd(sim_folder)

  tryCatch({
    if (verbose){
      out <- system2(glm_path, wait = TRUE, stdout = stdout, stderr = stderr)
    } else {
      out <- system2(glm_path, wait = TRUE, stdout = NULL, stderr = NULL)
    }
    setwd(origin)
  }, error = function(err) {
    print(paste("GLM_ERROR:  ",err))
    setwd(origin)
  })
}

