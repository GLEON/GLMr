#'@title run the GLM model
#'
#'@description
#'This runs the GLM model on the specific simulation stored in \code{sim_folder}. 
#'The specified \code{sim_folder} must contain a valid NML file.
#'
#'@param sim_folder the directory where simulation files are contained
#'@param verbose should output of GLM be shown
#'
#'@keywords methods
#'@author
#'Jordan Read, Luke Winslow
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
	
	if(!file.exists(file.path(sim_folder, 'glm.nml'))){
		stop('You must have a valid glm.nml file in your sim_folder: ', sim_folder)
	}
	
	#Just going to brute force this at the moment.
	if(.Platform$pkgType == "win.binary"){
		if(.Platform$r_arch != "x64"){
			warning("You are running a 32-bit version of R.", 
							"Windows GLM only supports 64-bit. This may cause issues.")
		}
		
		return(run_glmWin(sim_folder, verbose))
		
	}else if(.Platform$pkgType == "mac.binary" || 
					 	.Platform$pkgType == "mac.binary.mavericks"){
		
		return(run_glmOSx(sim_folder, verbose))
		
	}else if(.Platform$pkgType == "source"){
		## Probably running linux
		stop("Currently UNIX is not supported by ", getPackageName())
	}
	
}


run_glmWin <- function(sim_folder, verbose = TRUE){
	glm_path <- system.file('extbin/winGLM/glm.exe', package=getPackageName())
	origin <- getwd()
	setwd(sim_folder)
	
	tryCatch({
		if (verbose){
			out <- system2(glm_path, wait = TRUE, stdout = "", stderr = "")
		} else {
			out <- system2(glm_path, wait = TRUE, stdout = NULL, stderr = NULL)
		}
		setwd(origin)
		return(out)
	}, error = function(err) {
		print(paste("GLM_ERROR:  ",err))
		setwd(origin)
	})
}


run_glmOSx <- function(sim_folder, verbose = TRUE){
  lib_path <- system.file('extbin/macGLM/bin', package=getPackageName())
  glm_files <- dir(lib_path)
  glm_fp <- file.path(lib_path, glm_files)
  glm_path <- file.path(sim_folder,'glm')
  
  # ship glm and libs to sim_folder
  file_status <- file.copy(from=glm_fp, to=sim_folder, overwrite = TRUE, copy.mode = TRUE)
  # fail here if status fails
  if (any(!file_status)){
    stop(paste0("run_glm failed to copy model libraries to user's OSx directory: ",sim_folder))
  }
  
  origin <- getwd()
  setwd(sim_folder)

  tryCatch({
    if (verbose){
      out <- system2(glm_path, wait = TRUE, stdout = "", stderr = "")
      
    } else {
      out <- system2(glm_path, wait = TRUE, stdout = NULL, stderr = NULL)
    }
    file.remove(glm_files)
    setwd(origin)
	return(out)
  }, error = function(err) {
    print(paste("GLM_ERROR:  ",err))
    setwd(origin)
  })
}
