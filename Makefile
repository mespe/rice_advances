output/breed_paper.pdf: output/breed_paper.tex
	cd output && \
	pdflatex breed_paper.tex && \
	bibtex breed_paper && \
	pdflatex breed_paper.tex && \
	pdflatex breed_paper.tex 

output/breed_paper.tex: output/breed_paper.Rnw 
	cd output && R CMD Sweave breed_paper.Rnw

output/breed_paper.Rnw: data/all_vt_weather.Rda src/prep_model_data.R output/h1_fit.Rda

output/summary.pdf: output/summary.tex
	cd output && pdflatex summary.tex

output/summary.tex: output/summary.Rnw data/all_vt_weather.Rda src/prep_model_data.R output/h1_fit.Rda
	cd output && R CMD Sweave summary.Rnw

output/h1_fit.Rda: src/h1_model.R data/all_vt_weather.Rda src/prep_model_data.R src/yield_model.stan data/yrTbl.Rda
	cd src && Rscript h1_model.R

data/yrTbl.Rda: data/var_list.txt src/getYears.R
	cd src && Rscript getYears.R

clean:
	rm output/*.pdf
