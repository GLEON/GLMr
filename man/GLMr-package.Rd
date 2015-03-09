\name{GLMr-package}
\alias{GLMr-package}
\alias{GLMr}
\docType{package}
\title{
An R package containing the core GLM files for Mac, Windows, and Linux
}
\description{
This package is a handy wrapper for the General Lake Model. 
}
\details{
\tabular{ll}{
Package: \tab GLMr\cr
Type: \tab Package\cr
Version: \tab 2.0.0.6.2\cr
Date: \tab 2014-09-29\cr
License: \tab GPL 3.0\cr
}

\tabular{ll}{
Function \tab Description\cr
run_glm \tab Core model running function\cr
glm_version \tab Return version of GLM model\cr
nml_template_path \tab Return path to template NML file\cr
}

}
\author{
Luke A Winslow, Jordan S Read

Maintainer: Luke Winslow <lwinslow@usgs.gov>
}
\references{
	Hipsey, M.R., Bruce, L.C., Hamilton, D.P., 2013. 
  GLM General Lake Model. Model Overview and User Information.
  The University of Western Australia Technical Manual, Perth, Australia.
}

\keyword{ package }
\examples{
#Get the current version of GLM
glm_version()

#get the path to an NML file appropriate for the current version
nml_template_path() 


#Prep
sim_folder = tempdir()
example_nml <- system.file('extdata', 'glm2.nml', package = 'GLMr')
example_driver <- system.file('extdata','met_hourly.csv', package = 'GLMr')


#copy the MNL file
file.copy(example_nml, sim_folder)
file.copy(example_driver, sim_folder)


#run and visualize using glmtools
run_glm(sim_folder)
out_file <- file.path(sim_folder,'output.nc')

#run these only if we have glmtools available.
if(require(glmtools)){
	plot_temp(file = out_file)
}

}
