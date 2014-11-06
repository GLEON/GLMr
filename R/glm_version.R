#'@title Return the current GLM model version 
#'
#'@description 
#'Returns the current version of the GLM model being used
#'
#'@keywords methods
#'
#'@author
#'Luke Winslow, Jordan Read
#'@examples 
#' print(glm_version())
#'
#'
#'@export
glm_version <- function(){
  # them{2.0.0.4}.{us}
  pkg_version_lst <- as.character(packageVersion(getPackageName())[[1]])
  pkg_version <- strsplit(pkg_version_lst, '.', fixed = T)[[1]]
  num_elm <- length(pkg_version)
  GLM_version <- paste(head(pkg_version,num_elm-1), collapse='.')
	return(GLM_version)
}