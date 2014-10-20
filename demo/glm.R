
sim_folder <- system.file('extdata/sim/', package = 'GLMr')
if (run_glm(sim_folder,T)==0){
  cat('\n\n***')
  cat('Congratulations on setting up and running GLM!')
  cat('***\n\n')
} else {
  stop('setup failed, contact jread@usgs.gov with questions')
}

