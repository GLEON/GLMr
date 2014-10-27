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
#'sim_folder <- system.file('extdata/sim', package = 'GLMr')
#'run_glm(sim_folder)
#'out_file <- file.path(sim_folder,'output.nc')
#'nml_file <- system.file('extdata/sim', 'glm.nml', package = 'GLMr')
#'field_file <- system.file('extdata', 'field_data.tsv', package = 'GLMr')
#'plot_temp(file = out_file, fig_path = 'test_temp.png')
#'summarize_sim(out_file, sim_outputs = c('temp','surface_height','wind'))
#'
#' }
#'@export
run_glm <- function(sim_folder, verbose=TRUE){
	
	if(!file.exists(file.path(sim_folder, 'glm.nml'))){
		stop('You must have a valid glm.nml file in your sim_folder: ', sim_folder)
	}
	
	#Just going to brute force this at the moment.
	if(.Platform$pkgType == "win.binary"){
		
		return(run_glmWin(sim_folder, verbose))
		
	}else if(.Platform$pkgType == "mac.binary" || 
					 	.Platform$pkgType == "mac.binary.mavericks"){
    maj_v_number <- as.numeric(strsplit(Sys.info()["release"][[1]],'.', fixed = T)[[1]][1])
    if (maj_v_number < 13.0){
      stop('pre-mavericks mac OSX is not supported. Consider upgrading')
    }
		
		return(run_glmOSx(sim_folder, verbose))
		
	}else if(.Platform$pkgType == "source"){
		## Probably running linux
	  return(run_glmNIX(sim_folder, verbose))
		#stop("Currently UNIX is not supported by ", getPackageName())
	}
	
}


run_glmWin <- function(sim_folder, verbose = TRUE){
	
	if(.Platform$r_arch == 'i386'){
		glm_path <- system.file('extbin/win32GLM/glm.exe', package=getPackageName())
	}else{
		glm_path <- system.file('extbin/winGLM/glm.exe', package=getPackageName())
	}
	
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
  
  glm_path <- system.file('exec/macglm', package=getPackageName())
  
  # ship glm and libs to sim_folder
  Sys.setenv(DYLD_FALLBACK_LIBRARY_PATH=lib_path)
  
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

run_glmNIX = function(sim_folder, verbose=TRUE){
  glm_path <- system.file('exec/nixglm', package=getPackageName())
  origin <- getwd()
  setwd(sim_folder)
  Sys.setenv(LD_LIBRARY_PATH=system.file('extbin/nixGLM', package=getPackageName()))
  
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
