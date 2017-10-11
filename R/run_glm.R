#'@title run the GLM model
#'
#'@description
#'This runs the GLM model on the specific simulation stored in \code{sim_folder}. 
#'The specified \code{sim_folder} must contain a valid NML file.
#'
#'@param sim_folder the directory where simulation files are contained
#'@param verbose should output of GLM be shown
#'@param args Optional arguments to pass to GLM executable
#'
#'@keywords methods
#'@author
#'Jordan Read, Luke Winslow
#'@examples 
#'sim_folder <- system.file('extdata', package = 'GLMr')
#'run_glm(sim_folder)
#'\dontrun{
#'out_file <- file.path(sim_folder,'output.nc')
#'nml_file <- file.path(sim_folder,'glm2.nml')
#'library(glmtools)
#'fig_path <- tempfile("temperature", fileext = '.png')
#'plot_temp(file = out_file, fig_path = fig_path)
#'cat('find plot here: '); cat(fig_path)
#' }
#'@export
#'@importFrom utils packageName
run_glm <- function(sim_folder = '.', verbose=TRUE, args=character()){
	
	if(!file.exists(file.path(sim_folder, 'glm2.nml'))){
		stop('You must have a valid glm2.nml file in your sim_folder: ', sim_folder)
	}
	
	#Just going to brute force this at the moment.
	if(.Platform$pkgType == "win.binary"){
		
		return(run_glmWin(sim_folder, verbose, args))
		
	}else if(.Platform$pkgType == "mac.binary" || .Platform$pkgType == "mac.binary.el-capitan" ||
					 	.Platform$pkgType == "mac.binary.mavericks"){
    maj_v_number <- as.numeric(strsplit(
                      Sys.info()["release"][[1]],'.', fixed = TRUE)[[1]][1])
    if (maj_v_number < 13.0){
      stop('pre-mavericks mac OSX is not supported. Consider upgrading')
    }
		
		return(run_glmOSx(sim_folder, verbose, args))
		
	}else if(.Platform$pkgType == "source"){
		## Probably running linux
	  return(run_glmNIX(sim_folder, verbose, args))
		#stop("Currently UNIX is not supported by ", getPackageName())
	}
	
}


run_glmWin <- function(sim_folder, verbose = TRUE, args){
	
	if(.Platform$r_arch == 'i386'){
		glm_path <- system.file('extbin/win32GLM/glm.exe', package=packageName())
	}else{
		glm_path <- system.file('extbin/winGLM/glm.exe', package=packageName())
	}
	
	origin <- getwd()
	setwd(sim_folder)
	
	tryCatch({
		if (verbose){
			out <- system2(glm_path, wait = TRUE, stdout = "", 
			               stderr = "", args=args)
		} else {
			out <- system2(glm_path, wait = TRUE, stdout = NULL, 
			               stderr = NULL, args=args)
		}
		setwd(origin)
		return(out)
	}, error = function(err) {
		print(paste("GLM_ERROR:  ",err))
		setwd(origin)
	})
}


run_glmOSx <- function(sim_folder, verbose = TRUE, args){
  lib_path <- system.file('extbin/macGLM/bin', package=packageName())
  
  glm_path <- system.file('exec/macglm', package=packageName())
  
  # ship glm and libs to sim_folder
  # Sys.setenv(DYLD_FALLBACK_LIBRARY_PATH=lib_path)
  
  origin <- getwd()
  setwd(sim_folder)

  tryCatch({
    if (verbose){
      out <- system2(glm_path, wait = TRUE, stdout = "", 
                     stderr = "", args = args)
      
    } else {
      out <- system2(glm_path, wait = TRUE, stdout = NULL, 
                     stderr = NULL, args=args)
    }
    
    setwd(origin)
	return(out)
  }, error = function(err) {
    print(paste("GLM_ERROR:  ",err))
    
    setwd(origin)
  })
}

run_glmNIX <- function(sim_folder, verbose=TRUE, args){
  glm_path <- system.file('exec/nixglm', package=packageName())
  origin <- getwd()
  setwd(sim_folder)
  Sys.setenv(LD_LIBRARY_PATH=system.file('extbin/nixGLM', 
                                         package=packageName()))
  
  tryCatch({
    if (verbose){
      out <- system2(glm_path, wait = TRUE, stdout = "", 
                     stderr = "", args=args)
    } else {
      out <- system2(glm_path, wait = TRUE, stdout = NULL, 
                     stderr = NULL, args = args)
    }
    setwd(origin)
    return(out)
  }, error = function(err) {
    print(paste("GLM_ERROR:  ",err))
    setwd(origin)
  })
}
