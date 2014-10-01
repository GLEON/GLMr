#'@title Return the path to a current NML file template
#'
#'@description 
#'The NML file can change with updated versions of GLM. This returns a path to a valid 
#'NML template file matching the current GLM version.
#'
#'@keywords methods
#'
#'@author
#'Luke Winslow, Jordan Read
#'@examples 
#' edit(file=nml_template_path())
#'
#'
#'@export
nml_template_path <- function(){
	return(system.file('extdata/glm.nml', package=getPackageName()))
}