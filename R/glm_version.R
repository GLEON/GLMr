
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
	run_glm(dirname(nml_template_path()), verbose=TRUE, args='--help')
}
