#' @title Remerge the binaries with the library files for macGLM
#' 
#' @description This function remerges the macGLM binary file with
#' the libraries present in inst/extbin/macGLM/bin
#' 
#' @author Arianna Krinos
#' @importFrom utils packageName
remerge_binaries <- function() {
  lib_path = system.file("inst/extbin/macGLM/bin/", package = packageName())
  glm_path = system.file("exec/macGLM", package = packageName())
  files = list.files(lib_path)
  try ( system(paste0("install_name_tool -add_rpath ",lib_path, " ", 
                      glm_path)), silent = TRUE) # First try separate because possible
                                                 # rpath added without libraries linked
  try (
    {
      for (g in 1:length(files)) {
        system(paste0("install_name_tool -change ", "@executable_path/", 
                      files[g]," ", lib_path, files[g], " ", glm_path)) 
        for (h in 1:length(files)) {
          system(paste0("install_name_tool -change ", "@executable_path/", 
                      files[h]," ", lib_path, files[h], " ", lib_path,"/", files[g]))
        }
      }
    } , silent = TRUE)
}
